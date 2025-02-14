//
//  UserRequest.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

struct UserNicknameRequest: Codable {
    var nickname: String
}

struct UserPushRequest: Codable {
    var push: String
}
