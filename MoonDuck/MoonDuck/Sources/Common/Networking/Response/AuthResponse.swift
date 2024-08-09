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

struct ExitResponse: Codable {
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

struct RevokeTokenResponse: Codable {
    let revokeToken: String
}

struct AppleTokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let idToken: String
    let refreshToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
}
