//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import SwiftyJSON

struct UserResponse: Decodable {
    let userId: Int?
    let nickname: String?
    let movie: Int?
    let book: Int?
    let drama: Int?
    let concert: Int?
    
    var toDomain: UserV2 {
        let movie = movie ?? 0
        let book = book ?? 0
        let drama = drama ?? 0
        let concert = concert ?? 0
        let all: Int = {
            return movie + book + drama + concert
        }()
        
        return UserV2(userId: userId ??  0,
                      nickname: nickname ?? "",
                      all: all,
                      movie: movie,
                      book: book,
                      drama: drama,
                      concert: concert)
    }
}
struct TestUserResponse: Codable {
    let code: String?
    let message: String?
    
    let userId: Int?
    let nickname: String?
    let movie: Int?
    let book: Int?
    let drama: Int?
    let concert: Int?
    
    enum CodingKeys: CodingKey {
        case code, message, userId, nickname, movie, book, drama, concert
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try? values.decode(String.self, forKey: .code)
        message = try? values.decode(String.self, forKey: .message)
        userId = try? values.decode(Int.self, forKey: .userId)
        nickname = try? values.decode(String.self, forKey: .nickname)
        movie = try? values.decode(Int.self, forKey: .movie)
        book = try? values.decode(Int.self, forKey: .book)
        drama = try? values.decode(Int.self, forKey: .drama)
        concert = try? values.decode(Int.self, forKey: .concert)
    }
    var toDomain: UserV2 {
        let movie = movie ?? 0
        let book = book ?? 0
        let drama = drama ?? 0
        let concert = concert ?? 0
        let all: Int = {
            return movie + book + drama + concert
        }()
        
        return UserV2(userId: userId ??  0,
                      nickname: nickname ?? "",
                      all: all,
                      movie: movie,
                      book: book,
                      drama: drama,
                      concert: concert)
    }
}

struct UserNicknameResponse: Decodable {
    let userId: Int
    let nickname: String
}
