//
//  ReviewCategoryModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol ReviewCategoryModelType: AnyObject {
    var categories: [ReviewCategory] { get }
}

class ReviewCategoryModel: ReviewCategoryModelType {
    var categories: [ReviewCategory] = [.movie, .book, .drama, .concert]
}
