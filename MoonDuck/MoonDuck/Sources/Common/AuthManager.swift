//
//  AuthManager.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation
import UIKit

class AuthManager {
    static let current = AuthManager()
    
    //    private var token: String?
    //    private var refreshToken: String?
    private var token: Token?
    private var auth: Auth?
    private var user: UserV2?
    
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
    
    func saveUser(_ user: UserV2) {
        self.user = user
    }
    
    func removeUser() {
        self.user = nil
    }
    
    func getUser() -> UserV2? {
        return user
    }
    
    func getAutoLoginData() -> Auth? {
        if let isAutoLogin = AppUserDefaults.getObject(forKey: .isAutoLogin) as? Bool, isAutoLogin {
            guard let id = AppKeychain.getValue(forKey: .snsId),
                  let snsLoginType = AppUserDefaults.getObject(forKey: .snsLoginType) as? String,
                  let loginType = SnsLoginType(rawValue: snsLoginType) else { return nil }
            
            return Auth(loginType: loginType, id: id)
        } else {
            return nil
        }
    }
    
//    func login(_ user: UserV2) {
//        if let token {
//            AppKeychain.set(token, forKey: .accessToken)
//        }
//        if let refreshToken {
//            AppKeychain.set(refreshToken, forKey: .refreshToken)
//        }
//        AppUserDefaults.set(true, forKey: .isAutoLogin)
//        
//        self.user = user
//    }
    
    func logout() {
        removeAuth()
        removeToken()
        removeUser()
    }
    
    enum RefreshtTokenCode {
        case success
        case emptyToken
        case error
    }
    
    func refreshToken(_ provider: AuthService?, completion: @escaping (_ code: RefreshtTokenCode) -> Void) {
        guard let accessToken = token?.accessToken,
              let refreshToken = token?.refreshToken else {
            completion(.emptyToken)
            return
        }
        
        var provider = provider
        if provider == nil {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                provider = sceneDelegate.appService.authService
            } else {
                completion(.error)
                return
            }
        }
        
        let request = AuthReissueRequest(accessToken: accessToken, refreshToken: refreshToken)
        provider?.reissue(request: request) { succeed, failed in
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
