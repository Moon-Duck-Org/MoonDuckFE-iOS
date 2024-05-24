//
//  UserRequest.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

struct UserRequest: Encodable {
    var deviceId: String
}

struct UserLoginRequest: Encodable {
    var deviceId: String
}

struct UserNicknameRequest: Encodable {
    var deviceId: String
    var nickname: String
}
