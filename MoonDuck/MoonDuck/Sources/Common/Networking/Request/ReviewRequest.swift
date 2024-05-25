//
//  BoardRequest.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

struct ReviewAllRequest: Encodable {
    var userId: Int
    var filter: String
}

struct GetReviewRequest: Encodable {
    var userId: Int
    var category: String
    var filter: String
}

struct PutReviewRequest: Encodable {
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

struct PostReviewRequest: Encodable {
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

struct DeleteReviewRequest: Encodable {
    var boardId: Int
}

struct ReviewDetailRequest: Encodable {
    var boardId: Int
}
