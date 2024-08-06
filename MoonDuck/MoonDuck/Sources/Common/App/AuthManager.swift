//
//  AuthManager.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation
import UIKit

import KakaoSDKUser
import GoogleSignIn
import AuthenticationServices

class AuthManager {
    static let shared = AuthManager()
    
    private var provider: AppServices?
    
    func initProvider(_ provider: AppServices) {
        self.provider = provider
    }
        
    func saveAuth(_ auth: Auth) {
        Secrets.auth = auth
    }
    
    func removeAuth() {
        Secrets.auth = nil        
    }
    
    func saveToken(_ token: Token) {
        Secrets.token = token
    }
    
    func removeToken() {
        Secrets.token = nil
    }
    
    func saveUserId(_ id: Int) {
        Secrets.userId = id
    }
    
    func removeUserId() {
        Secrets.userId = nil
    }
    
    func getAccessToken() -> String? {
        return Secrets.token?.accessToken
    }
    
    func getRefreshToken() -> String? {
        return Secrets.token?.refreshToken
    }
    
    func getAutoLoginAuth() -> Auth? {
        return Secrets.getAutoLoginAuth()
    }
    
    func getLoginType() -> SnsLoginType? {
        return Secrets.auth?.loginType
    }
        
    func withdraw(completion: @escaping (_ isSuccess: Bool, _ error: APIError?) -> Void) {
        if let loginType = getLoginType() {
            switch loginType {
            case .kakao:
                withdrawWithKakao { [weak self] _ in
                    self?.exit(completion: completion)
                }
            case .apple:
                completion(false, .unknown)
            case .google:
                withdrawWithGoogle { [weak self] _ in
                    self?.exit(completion: completion)
                }
            }
        } else {
            completion(false, .auth)
        }
    }
    
    func removeAppUserData() {
        removeAuth()
        removeToken()
        removeUserId()
    }
    
    func login(auth: Auth, completion: @escaping (_ isHaveNickname: Bool?, _ failed: APIError?) -> Void) {
        let request = LoginRequest(dvsnCd: auth.loginType.rawValue, id: auth.id)
        provider?.authService.login(request: request) { succeed, failed in
            if let succeed {
                // 앱에 토큰 및 로그인 정보 저장
                AuthManager.shared.saveAuth(auth)
                AuthManager.shared.saveToken(
                    Token(accessToken: succeed.accessToken,
                          refreshToken: succeed.refreshToken)
                )
                AuthManager.shared.saveUserId(succeed.userId)
                completion(succeed.isHaveNickname, nil)
            } else {
                completion(nil, failed)
            }
        }
    }
    
    func logout() {
        provider?.authService.logout { _, _ in }
        
        if let loginType = getLoginType() {
            switch loginType {
            case .kakao: logoutWithKakao { _ in }
            case .apple: break
            case .google: logoutWithGoogle()
            }
        }
        
        removeAppUserData()
    }
    
    func exit(completion: @escaping (_ isSuccess: Bool, _ error: APIError?) -> Void) {
        provider?.authService.exit { succeed, failed in
            if succeed != nil {
                completion(true, nil)
            } else {
                // 오류 발생
                let snsType = AuthManager.shared.getLoginType()?.rawValue ?? ""
                AnalyticsService.shared.logEvent(
                    .FAIL_WITHDRAW,
                    parameters: [.SNS_TYPE: snsType,
                                 .ERROR_CODE: failed?.code ?? "",
                                 .ERROR_MESSAGE: failed?.message ?? "",
                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()])
                completion(false, failed)
            }
        }
    }
    
    func revokeToken(completion: @escaping (_ success: String?, _ error: APIError?) -> Void) {
        let request = RevokeTokenRequest()
        provider?.authService.revokeToken(request: request) { succeed, failed in
            completion(succeed, failed)
        }
    }
    
    func refreshToken(completion: @escaping (_ success: Bool, _ error: APIError?) -> Void) {
        guard let accessToken = Secrets.token?.accessToken,
              let refreshToken = Secrets.token?.refreshToken,
              let userId = Secrets.userId else {
            completion(false, .unknown)
            return
        }
        
        let request = ReissueRequest(accessToken: accessToken, refreshToken: refreshToken, userId: userId)
        provider?.authService.reissue(request: request) { succeed, failed in
            if let succeed {
                self.saveToken(succeed)
                completion(true, nil)
            } else {
                completion(false, failed)
            }
        }
    }
}

// MARK: - SNS Login Manager
extension AuthManager {
    private func logoutWithKakao(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.logout { error in
            if let error {
                Log.error("로그아웃 실패: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                Log.debug("로그아웃 성공")
                completion(.success(()))
            }
        }
    }
    
    private func withdrawWithKakao(completion: @escaping (Result<Void, Error>) -> Void) {
        UserApi.shared.unlink { error in
            if let error {
                Log.error("카카오 연동 해제 실패: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                Log.debug("카카오 연동 해제 성공")
                completion(.success(()))
            }
        }
    }
    
    private func logoutWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    private func withdrawWithGoogle(completion: @escaping (Result<Void, Error>) -> Void) {
        // 사용자 정보를 삭제하고 로그아웃 처리
        GIDSignIn.sharedInstance.disconnect { error in
            if let error {
                Log.error("구글 연결 해제 실패: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                Log.debug("구글 연결 해제 성공")
                completion(.success(()))
            }
        }
    }
    
    private func appleToken(clientSecret: String, authorizationCode: String, completion: @escaping (_ token: String?, _ error: APIError?) -> Void) {
        let request = AppleTokenRequest(clientSecret: clientSecret, code: authorizationCode)
        provider?.authService.appleToken(request: request, completion: { succeed, failed in
            if let succeed {
                completion(succeed.accessToken, nil)
            } else {
                completion(nil, failed)
            }
        })
    }
    
    private func revokeApple(clientSecret: String, token: String, completion: @escaping (_ isSuccess: Bool, _ error: APIError?) -> Void) {
        let request = RevokeAppleRequest(clientSecret: clientSecret, token: token)
        provider?.authService.revokeApple(request: request, completion: { succeed, failed in
            if let succeed, succeed {
                completion(true, nil)
            } else {
                completion(false, failed)
            }
        })
    }
    
    func withdrawWithApple(authorizationCode: String, completion: @escaping (_ isSuccess: Bool, _ error: APIError?) -> Void) {
        // STEP 1. Apple Auth Code 발급 -> VC에서 수행
        // STEP 2. JWT Token 발급
        revokeToken { [weak self] clientSecret, error in
            if let clientSecret {
                // STEP 3. Apple Token 발급
                self?.appleToken(clientSecret: clientSecret, authorizationCode: authorizationCode) { [weak self] token, error in
                    // STEP 4. Revoke Token 요청
                    if let token {
                        self?.revokeApple(clientSecret: clientSecret, token: token) { [weak self] isSuccess, error in
                            if isSuccess {
                                // STEP 5. 앱 회원 탈퇴
                                self?.exit(completion: completion)
                            } else {
                                // STEP 5 ERROR. 로그만 보내고 앱 회원 탈퇴 진행
                                AnalyticsService.shared.logEvent(
                                    .FAIL_APPLE_LOGIN_AUTH,
                                    parameters: [.AUTH_TYPE: "REVOKE",
                                                 .ERROR_CODE: error?.code ?? "",
                                                 .ERROR_MESSAGE: error?.message ?? "",
                                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()
                                    ]
                                )
                                self?.exit(completion: completion)
                            }
                        }
                    } else {
                        // STEP 4 ERROR. 로그만 보내고 앱 회원 탈퇴 진행
                        AnalyticsService.shared.logEvent(
                            .FAIL_APPLE_LOGIN_AUTH,
                            parameters: [.AUTH_TYPE: "TOKEN",
                                         .ERROR_CODE: error?.code ?? "",
                                         .ERROR_MESSAGE: error?.message ?? "",
                                         .TIME_STAMP: Utils.getCurrentKSTTimestamp()
                            ]
                        )
                        self?.exit(completion: completion)
                    }
                }
            } else {
                completion(false, error)
            }
        }
    }
}
