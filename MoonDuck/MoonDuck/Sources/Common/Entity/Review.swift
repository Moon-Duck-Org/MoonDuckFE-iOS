//
//  Review.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

struct Review {
    let id: Int?
    var title: String
    var category: Category
    let user: User
    var program: Program
    var content: String
    var imageUrlList: [String]
    var link: String?
    var rating: Int
    let createdAt: String
        
    struct User {
        let userId: Int
        let nickname: String
    }
}
