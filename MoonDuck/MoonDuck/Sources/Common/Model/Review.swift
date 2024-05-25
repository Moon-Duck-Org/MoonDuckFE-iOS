//
//  Review.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation

struct Review {
    let id: Int
    var title: String
    let created: String
    let nickname: String
    
    var category: Category
    var content: String
    var imageUrlList: [String]
    var link: String?
    var starRating: Int
}
