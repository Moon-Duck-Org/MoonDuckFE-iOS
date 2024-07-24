//
//  CategoryModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol CategoryModelDelegate: BaseModelDelegate {
    func categoryModel(_ model: CategoryModelType, didChange categories: [Category])
    func categoryModel(_ model: CategoryModelType, didSelect category: Category)
    func categoryModel(_ model: CategoryModelType, didReload category: Category)
}

extension CategoryModelDelegate {
    func categoryModel(_ model: CategoryModelType, didReload category: Category) { }
}

protocol CategoryModelType: BaseModelType {
    // Data
    var delegate: CategoryModelDelegate? { get set }
    var categories: [Category] { get }
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    var selectedCategory: Category? { get set }
    
    func category(at index: Int) -> Category?
    
    // Action
    func selectCategory(at index: Int)
    func reloadCategory()
    
    // Netwok
    func getCategories(isHaveAll: Bool)
}

class CategoryModel: CategoryModelType {
    // MARK: - Data
    weak var delegate: CategoryModelDelegate?
    
    var categories: [Category] = [] {
        didSet {
            delegate?.categoryModel(self, didChange: categories)
        }
    }
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    var indexOfSelectedCategory: Int?
    
    var selectedCategory: Category?
    
    func category(at index: Int) -> Category? {
        if index < categories.count {
            return categories[index]
        }
        return nil
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        if indexOfSelectedCategory == index { return }
        indexOfSelectedCategory = index
        selectedCategory = category(at: index)
        if let selectedCategory {
            delegate?.categoryModel(self, didSelect: selectedCategory)
        }
    }
    
    func reloadCategory() {
        indexOfSelectedCategory = 0
        selectedCategory = category(at: 0)
        if let selectedCategory {
            delegate?.categoryModel(self, didReload: selectedCategory)
        }
    }
    
    // MARK: - Networking
    func getCategories(isHaveAll: Bool) {
        if isHaveAll {
            categories = [.all, .movie, .book, .drama, .concert]
        } else {
            categories = [.movie, .book, .drama, .concert]
        }
        
        if let selectedCategory,
           let index = categories.firstIndex(of: selectedCategory) {
            selectCategory(at: index)
        }
    }
}
