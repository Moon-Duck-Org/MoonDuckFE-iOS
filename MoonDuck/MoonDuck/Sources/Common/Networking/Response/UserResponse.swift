//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserResponse: Decodable {
    let id: Int
    let deviceId: String
    let nickname: String
    let movie: Int?
    let book: Int?
    let drama: Int?
    let concert: Int?
}

extension UserResponse {
    var toDomain: User {
        let movie = movie ?? 0
        let book = book ?? 0
        let drama = drama ?? 0
        let concert = concert ?? 0
        let all: Int = {
            return movie + book + drama + concert
        }()
        
        return User(id: id,
                    deviceId: deviceId,
                    nickname: nickname,
                    all: all,
                    movie: movie,
                    book: book,
                    drama: drama,
                    concert: concert)
    }
}
