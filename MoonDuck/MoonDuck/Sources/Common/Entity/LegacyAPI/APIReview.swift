//
//  Review.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

// MARK: - API Version

import UIKit

struct APIReview {
    let id: Int?
    var rating: Int
    
    var createdAt: String
    
    var category: Category
    var program: Program
    
    var title: String
    var link: String?
    var content: String
    var imageUrlList: [String]
    
    let user: User
    struct User {
        let userId: Int
        let nickname: String
    }
}
