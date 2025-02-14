//
//  Review.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

struct Review {
    let id: Int?
    var rating: Int
    
    var createdAt: String
    var modifiedAt: String
    
    var category: Category
    var program: Program
    
    var title: String
    var link: String?
    var content: String
    var imageUrlList: [String]
    
    // API 제거 후, 미사용
    let user: User
    struct User {
        let userId: Int
        let nickname: String
    }
}
