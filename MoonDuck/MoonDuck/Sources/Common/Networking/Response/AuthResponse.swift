//
//  AuthResponse.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isHaveNickname: Bool
    let userId: Int
}

struct LogoutResponse: Codable {
    let userId: Int
}

struct ReissueResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    var toDomain: Token {
        return Token(accessToken: accessToken,
                     refreshToken: refreshToken)
    }
}
