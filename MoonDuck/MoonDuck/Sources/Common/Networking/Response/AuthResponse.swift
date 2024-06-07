//
//  AuthResponse.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

import SwiftyJSON

struct AuthLoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let isHaveNickname: Bool
}
