//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserResponse: Decodable {
    let userId: Int
    let nickname: String
    let movie: Int?
    let book: Int?
    let drama: Int?
    let concert: Int?
}

struct UserNicknameResponse: Decodable {
    let userId: Int
    let nickname: String
}

extension UserResponse {
    var toDomain: UserV2 {
        let movie = movie ?? 0
        let book = book ?? 0
        let drama = drama ?? 0
        let concert = concert ?? 0
        let all: Int = {
            return movie + book + drama + concert
        }()
        
        return UserV2(userId: userId,
                    nickname: nickname,
                    all: all,
                    movie: movie,
                    book: book,
                    drama: drama,
                    concert: concert)
    }
}
