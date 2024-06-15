//
//  BoardRequest.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

struct ReviewAllRequest: Codable {
    var userId: Int
    var filter: String
}

struct GetReviewRequest: Codable {
    var userId: Int
    var category: String
    var filter: String
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
    var content: String
    var image1: String?
    var image2: String?
    var image3: String?
    var image4: String?
    var image5: String?
    var url: String?
    var score: Int
    var userId: Int
}

struct DeleteReviewRequest: Codable {
    var boardId: Int
}

struct ReviewDetailRequest: Codable {
    var boardId: Int
}
