//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserRseponse: Decodable {
    let id: Int
    let deviceId: String
    let nickname: String
    let movie: Int
    let book: Int
    let drama: Int
    let concert: Int
}

extension UserRseponse {
    var toDomain: User {
        return User(deviceId: deviceId,
                    nickname: nickname,
                    movie: movie,
                    book: book,
                    drama: drama,
                    concert: concert)
    }
}
