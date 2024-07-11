//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserResponse: Codable {
    let userId: Int
    let nickname: String?
    let movie: Int?
    let book: Int?
    let drama: Int?
    let concert: Int?
    let push: String?
    
    var toDomain: User {
        let movie = movie ?? 0
        let book = book ?? 0
        let drama = drama ?? 0
        let concert = concert ?? 0
        let all: Int = {
            return movie + book + drama + concert
        }()
        let isPush: Bool = {
            if let push, let isPush = push.toBool() {
                return isPush
            }
            return false
        }()
        
        return User(userId: userId,
                    nickname: nickname ?? "",
                    all: all,
                    movie: movie,
                    book: book,
                    drama: drama,
                    concert: concert,
                    isPush: isPush)
    }
}

struct UserNicknameResponse: Codable {
    let userId: Int
    let nickname: String
}
