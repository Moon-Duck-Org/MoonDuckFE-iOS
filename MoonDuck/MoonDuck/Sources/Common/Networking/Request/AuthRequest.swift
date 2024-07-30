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
    var clientId: String = Utils.appBundleId
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
