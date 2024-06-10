//
//  AuthManager.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation
import UIKit

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
        removeAuth()
        removeToken()
    }
    
    enum LoginResultCode {
        case success
        case error
        case donthaveNickname
    }
    
    func login(auth: Auth, completion: @escaping (LoginResultCode) -> Void) {
        let request = AuthLoginRequest(dvsnCd: auth.loginType.rawValue, id: auth.id)
        provider?.authService.login(request: request) { succeed, failed in
            if let succeed {
                // 앱에 토큰 및 로그인 정보 저장
                AuthManager.default.saveAuth(auth)
                AuthManager.default.saveToken(
                    Token(accessToken: succeed.accessToken,
                          refreshToken: succeed.refreshToken)
                )
                if succeed.isHaveNickname {
                    completion(.success)
                } else {
                    completion(.donthaveNickname)
                }
            } else {
                Log.error(failed?.localizedDescription ?? "Login Error")
                completion(.error)
            }
        }
    }
    
    enum RefreshtTokenResultCode {
        case success
        case emptyToken
        case error
    }
    
    func refreshToken(completion: @escaping (_ code: RefreshtTokenResultCode) -> Void) {
        guard let accessToken = token?.accessToken,
              let refreshToken = token?.refreshToken else {
            completion(.emptyToken)
            return
        }
        
        let request = AuthReissueRequest(accessToken: accessToken, refreshToken: refreshToken)
        provider?.authService.reissue(request: request) { succeed, failed in
            if let succeed {
                self.saveToken(succeed)
                completion(.success)
            } else {
                Log.error(failed?.localizedDescription ?? "Auth Reissue Error")
                completion(.error)
            }
        }
    }
}
