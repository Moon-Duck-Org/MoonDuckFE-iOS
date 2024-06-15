//
//  ReviewCategoryModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol ReviewCategoryModelDelegate: AnyObject {
    func reviewCategoryModel(_ model: ReviewCategoryModel, didChange categories: [ReviewCategory])
    func reviewCategoryModel(_ model: ReviewCategoryModel, didSelect index: Int?)
}

protocol ReviewCategoryModelType: AnyObject {
    /// Data
    var delegate: ReviewCategoryModelDelegate? { get set }
    var categories: [ReviewCategory] { get }
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    var selectedCategory: ReviewCategory? { get }
    
    func category(at index: Int) -> ReviewCategory?
    
    /// Action
    func selectCategory(_ index: Int)
    
    /// Netwok
    func getCategories(isHaveAll: Bool)
}

class ReviewCategoryModel: ReviewCategoryModelType {
    // MARK: - Data
    weak var delegate: ReviewCategoryModelDelegate?
    
    var categories: [ReviewCategory] = [] {
        didSet {
            delegate?.reviewCategoryModel(self, didChange: categories)
        }
    }
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    var indexOfSelectedCategory: Int? {
        didSet {
            delegate?.reviewCategoryModel(self, didSelect: indexOfSelectedCategory)
        }
    }
    
    var selectedCategory: ReviewCategory? {
        if let indexOfSelectedCategory {
            return category(at: indexOfSelectedCategory)
        }
        return nil
    }
    
    func category(at index: Int) -> ReviewCategory? {
        if index < categories.count {
            return categories[index]
        }
        return nil
    }
    
    // MARK: - Action
    func selectCategory(_ index: Int) {
        indexOfSelectedCategory = index
    }
    
    // MARK: - Networking
    func getCategories(isHaveAll: Bool) {
        if isHaveAll {
            categories = [.all, .movie, .book, .drama, .concert]
        } else {
            categories = [.movie, .book, .drama, .concert]
        }
    }
}
