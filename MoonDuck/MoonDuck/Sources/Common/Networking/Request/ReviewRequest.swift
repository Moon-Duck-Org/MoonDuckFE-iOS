//
//  BoardRequest.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

struct ReviewAllRequest: Codable {
    var filter: String
    var offset: Int
    var size: Int
}

struct GetReviewRequest: Codable {
    var category: String
    var filter: String
    var offset: Int
    var size: Int
}

struct PutReviewRequest: Codable {
    var title: String
    var category: String
    var content: String
    var image1: String?
    var image2: String?
    var image3: String?
    var image4: String?
    var image5: String?
    var url: String?
    var score: Int
    var boardId: Int
}

struct PostReviewRequest: Codable {
    var title: String
    var category: String
    var program: ProgramRequest?
    var content: String
    var url: String
    var score: Int
}

struct ProgramRequest: Codable {
    var programType: String
    var title: String
    var date: String?
    var genre: String?
    var director: String?
    var actor: String?
    var publisher: String?
    var place: String?
    var price: String?
    
    enum CodingKeys: String, CodingKey {
        case title, date, genre, director, actor, publisher, place, price
        case programType = "program_type"
    }
    
    init(program: Program) {
        self.programType = program.category.apiKey
        self.title = program.title
        self.date = program.date
        self.genre = program.genre
        self.director = program.director
        self.actor = program.actor
        self.publisher = program.publisher
        self.place = program.place
        self.price = program.price
    }
}

struct DeleteReviewRequest: Codable {
    var boardId: Int
}

struct ReviewDetailRequest: Codable {
    var boardId: Int
}
