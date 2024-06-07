//
//  AuthRequest.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

struct AuthLoginRequest: Encodable {
    var dvsnCd: String  // 소셜 로그인 타입
    var id: String      // 소셜 로그인 ID
}

struct AuthReissueRequest: Encodable {
    var accessToken: String
    var refreshToken: String
}
