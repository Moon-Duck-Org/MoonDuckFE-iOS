//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserRseponse: Decodable {
    let modifiedAt: String
    let deviceId: String
    let userid: Int
    let nickname: String
    let createdAt: String
}

extension UserRseponse {
    var toDomain: User {
        return User(deviceId: deviceId,
                    nickname: nickname)
    }
}
