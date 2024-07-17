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
    static let `default` = AuthManager()
    
    private var token: Token?
    private var auth: Auth?
    private var provider: AppServices?
    
    func initProvider(_ provider: AppServices) {
        self.provider = provider
    }
        
    func saveAuth(_ auth: Auth) {
        self.auth = auth
        
        AppKeychain.set(auth.id, forKey: .snsId)
        AppUserDefaults.set(auth.loginType.rawValue, forKey: .snsLoginType)
        AppUserDefaults.set(true, forKey: .isAutoLogin)
    }
    
    func removeAuth() {
        self.auth = nil
        
        AppKeychain.remove(forKey: .snsId)
        AppUserDefaults.remove(forKey: .snsLoginType)
        AppUserDefaults.set(false, forKey: .isAutoLogin)
    }
    
    func saveToken(_ token: Token) {
        self.token = token
    }
    
    func removeToken() {
        self.token = nil
    }
    
    func getAccessToken() -> String? {
        return token?.accessToken
    }
    
    func getRefreshToken() -> String? {
        return token?.refreshToken
    }
    
    func getAutoLoginAuth() -> Auth? {
        if let isAutoLogin = AppUserDefaults.getObject(forKey: .isAutoLogin) as? Bool, isAutoLogin,
           let id = AppKeychain.getValue(forKey: .snsId),
           let snsLoginType = AppUserDefaults.getObject(forKey: .snsLoginType) as? String,
           let loginType = SnsLoginType(rawValue: snsLoginType) {
            return Auth(loginType: loginType, id: id)
        } else {
            return nil
        }
    }
    
    func logout() {
        if let auth {
            switch auth.loginType {
            case .kakao: logoutWithKakao { _ in }
            case .apple: break
            case .google: logoutWithGoogle()
            }
        }
        
        removeAuth()
        removeToken()
    }
    
    func withDraw() {
        if let auth {
            switch auth.loginType {
            case .kakao: withdrawWithKakao { _ in }
            case .apple: break
            case .google: withdrawWithGoogle { _ in }
            }
        }
        
        removeAuth()
        removeToken()
    }
    
    enum LoginResultCode {
        case success
        case error
        case donthaveNickname
    }
    
    func login(auth: Auth, completion: @escaping (_ isHaveNickname: Bool?, _ failed: APIError?) -> Void) {
        let request = AuthLoginRequest(dvsnCd: auth.loginType.rawValue, id: auth.id)
        provider?.authService.login(request: request) { succeed, failed in
            if let succeed {
                // 앱에 토큰 및 로그인 정보 저장
                AuthManager.default.saveAuth(auth)
                AuthManager.default.saveToken(
                    Token(accessToken: succeed.accessToken,
                          refreshToken: succeed.refreshToken)
                )
                completion(succeed.isHaveNickname, nil)
            } else {
                completion(nil, failed)
            }
        }
    }
    
    func refreshToken(completion: @escaping (_ success: Bool, _ error: APIError?) -> Void) {
        guard let accessToken = token?.accessToken,
              let refreshToken = token?.refreshToken else {
            completion(false, .unknown)
            return
        }
        
        let request = AuthReissueRequest(accessToken: accessToken, refreshToken: refreshToken)
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
            } else {
                Log.debug("로그아웃 성공")
                // 앱 내에서 로그아웃 후의 처리를 추가합니다.
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
        let request = AuthRevokeAppleRequest(clientSecret: clientSecret, token: token)
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
