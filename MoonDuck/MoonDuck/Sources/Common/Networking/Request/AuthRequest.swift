//
//  AuthRequest.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

struct LoginRequest: Codable {
    var dvsnCd: String  // 소셜 로그인 타입
    var id: String      // 소셜 로그인 ID
}

struct ReissueRequest: Codable {
    var accessToken: String
    var refreshToken: String
    var userId: Int
}

struct RevokeAppleRequest: Codable {
    var clientId: String = Constants.appBundleId
    var clientSecret: String
    var token: String
    var tokenTypeHint: String = "access_token"
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case token
        case tokenTypeHint = "token_type_hint"
    }
}

struct AppleTokenRequest: Codable {
    var clientId: String = Constants.appBundleId
    var clientSecret: String
    var code: String
    var grantType: String = "authorization_code"
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
        case grantType = "grant_type"
    }
}

struct  RevokeTokenRequest: Codable {
    var keyId: String  = Constants.signInAppleKeyId
    var teamId: String = Constants.teamId
    var audience: String = "https://appleid.apple.com"
    var subject: String = Constants.appBundleId
}
