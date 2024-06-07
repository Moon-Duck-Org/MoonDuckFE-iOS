//
//  AuthManager.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

class AuthManager {
    static let current = AuthManager()
    
    private var token: String?
    private var refreshToken: String?
    private var user: UserV2?
    
    func getToken() -> String? {
        return token
    }
    
    func getRefreshToken() -> String? {
        return refreshToken
    }
    
    func saveToken(_ token: String, _ refreshToken: String) {
        self.token = token
        self.refreshToken = refreshToken
    }
    
    func removeToken() {
        self.token = nil
        self.refreshToken = nil
    }
    
    func autoLogin() -> Bool {
        if let isAutoLogin = AppUserDefaults.getObject(forKey: .isAutoLogin) as? Bool, isAutoLogin {
            guard let token = AppKeychain.getValue(forKey: .accessToken),
                  let refreshToken = AppKeychain.getValue(forKey: .refreshToken) else { return false }
            self.saveToken(token, refreshToken)
            return true
        } else {
            return false
        }
    }
    
    func login(_ user: UserV2) {
        if let token {
            AppKeychain.set(token, forKey: .accessToken)
        }
        if let refreshToken {
            AppKeychain.set(refreshToken, forKey: .refreshToken)
        }
        AppUserDefaults.set(true, forKey: .isAutoLogin)
        
        self.user = user
    }
    
    func logout() {
        self.removeToken()
        self.user = nil
        
        AppKeychain.remove(forKey: .accessToken)
        AppKeychain.remove(forKey: .refreshToken)
        AppUserDefaults.set(false, forKey: .isAutoLogin)
    }
    
    enum RefreshtTokenCode {
        case success
        case emptyToken
        case error
    }
    
    func refreshToken(_ provider: AuthService, completion: @escaping (_ code: RefreshtTokenCode) -> Void) {
        guard let token = AppKeychain.getValue(forKey: .accessToken),
              let refreshToken = AppKeychain.getValue(forKey: .refreshToken) else {
            completion(.emptyToken)
            return
        }
        
        let request = AuthReissueRequest(accessToken: token, refreshToken: refreshToken)
        provider.reissue(request: request) { succeed, failed in
            if let succeed {
                self.saveToken(succeed.accessToken, succeed.refreshToken)
                completion(.success)
            } else {
                Log.error(failed?.localizedDescription ?? "Auth Reissue Error")
                completion(.error)
            }
        }
    }
}
