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
        
    func withDraw() {
        if let auth = Secrets.auth {
            switch auth.loginType {
            case .kakao: withdrawWithKakao { _ in }
            case .apple: break // TODO: - 애플 로그인 해제
            case .google: withdrawWithGoogle { _ in }
            }
        }
        
        removeAuth()
        removeToken()
        removeUserId()
    }
    
    enum LoginResultCode {
        case success
        case error
        case donthaveNickname
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
        provider?.authService.logout {  _, _ in  }
        
        if let auth = Secrets.auth {
            switch auth.loginType {
            case .kakao: logoutWithKakao { _ in }
            case .apple: break
            case .google: logoutWithGoogle()
            }
        }
        
        removeAuth()
        removeToken()
        removeUserId()
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
    
    private func withdrawWithApple(clientSecret: String, token: String, completion: @escaping (Result<Void, Error>?) -> Void) {
        let request = RevokeAppleRequest(clientSecret: clientSecret, token: token)
        provider?.authService.revokeApple(request: request, completion: { succeed, failed in
            if let failed {
                Log.error("에플 연결 해제 실패: \(failed.localizedDescription)")
                completion(.failure(failed))
            } else if let succeed {
                if succeed {
                    Log.error("에플 연결 해제 성공")
                    completion(.success(()))
                } else {
                    Log.error("에플 연결 해제 실패")
                    completion(nil)
                }
            }
        })
    }
}
