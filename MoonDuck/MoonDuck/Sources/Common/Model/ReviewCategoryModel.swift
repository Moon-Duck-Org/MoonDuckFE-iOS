//
//  ReviewCategoryModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol ReviewCategoryModelDelegate: AnyObject {
    
}

protocol ReviewCategoryModelType: AnyObject {
    func getNumberOfCategories(haveAll: Bool) -> Int
    func getCategories(haveAll: Bool) -> [ReviewCategory]
}

class ReviewCategoryModel: ReviewCategoryModelType {
    var categories: [ReviewCategory] = [.all, .movie, .book, .drama, .concert]
    
    func getNumberOfCategories(haveAll: Bool) -> Int {
        return getCategories(haveAll: haveAll).count
    }
    
    func getCategories(haveAll: Bool) -> [ReviewCategory] {
        if haveAll {
            return categories
        } else {
            return Array(categories.dropFirst())
        }
    }
}
