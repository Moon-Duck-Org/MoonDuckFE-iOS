//
//  AuthResponse.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

struct AuthLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isHaveNickname: Bool
}

struct AuthReissueResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    var toDomain: Token {
        return Token(accessToken: accessToken,
                     refreshToken: refreshToken)
    }
}
