//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserRseponse: Decodable {
    let createdAt: String
    let modifiedAt: String
    let id: Int
    let deviceId: String
    let nickname: String
}

extension UserRseponse {
    var toDomain: User {
        return User(deviceId: deviceId, nickname: nickname)
    }
}

struct User {
    let deviceId: String
    let nickname: String
}
