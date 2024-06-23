//
//  CategoryModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol CategoryModelDelegate: AnyObject {
    func category(_ model: CategoryModel, didChange categories: [Category])
    func category(_ model: CategoryModel, didSelect index: Int?)
}

protocol CategoryModelType: AnyObject {
    // Data
    var delegate: CategoryModelDelegate? { get set }
    var categories: [Category] { get }
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    var selectedCategory: Category? { get }
    
    func category(at index: Int) -> Category?
    
    // Action
    func selectCategory(_ index: Int)
    
    // Netwok
    func getCategories(isHaveAll: Bool)
}

class CategoryModel: CategoryModelType {
    // MARK: - Data
    weak var delegate: CategoryModelDelegate?
    
    var categories: [Category] = [] {
        didSet {
            delegate?.category(self, didChange: categories)
        }
    }
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    var indexOfSelectedCategory: Int? {
        didSet {
            delegate?.category(self, didSelect: indexOfSelectedCategory)
        }
    }
    
    var selectedCategory: Category? {
        if let indexOfSelectedCategory {
            return category(at: indexOfSelectedCategory)
        }
        return nil
    }
    
    func category(at index: Int) -> Category? {
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
