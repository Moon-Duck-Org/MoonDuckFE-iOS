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
    private var user: User?
    
    func getToken() -> String? {
        return token
    }
    
    func saveToken(_ token: String, _ refreshToken: String) {
        AppKeychain.set(token, forKey: .accessToken)
        AppKeychain.set(refreshToken, forKey: .refreshToken)
        
        self.token = token
    }
    
    func loginUser() {
        
    }
    
    func logOut() {
        token = nil
        user = nil
    }
}
