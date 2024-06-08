//
//  Auth.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

enum SnsLoginType: String {
    case kakao = "KAKAO"
    case google = "GOOGLE"
    case apple = "APPLE"
}

struct Auth {
    let loginType: SnsLoginType
    let id: String
}

struct Token {
    let accessToken: String
    let refreshToken: String
}
