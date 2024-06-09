//
//  WriteReviewCategoryViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol WriteReviewCategoryPresenter: AnyObject {
    var view: WriteReviewCategoryView? { get set }
    
    /// Data
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    
    func category(at index: Int) -> ReviewCategory?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func selectCategory(at index: Int)
}

class WriteReviewCategoryViewPresenter: Presenter, WriteReviewCategoryPresenter {
    weak var view: WriteReviewCategoryView?
    let model: ReviewCategoryModelType
    
    init(with provider: AppServices, model: ReviewCategoryModelType) {
        self.model = model
        super.init(with: provider)
    }
    
    // MARK: - Data
    var numberOfCategories: Int {
        return model.categories.count
    }
    
    var indexOfSelectedCategory: Int?
    
    func category(at index: Int) -> ReviewCategory? {
        if index < model.categories.count {
            return model.categories[index]
        } else {
            return nil
        }
    }
}

extension WriteReviewCategoryViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        indexOfSelectedCategory = index
        view?.reloadCategories()
    }
    
}

// MARK: - UserModelDelegate
extension WriteReviewCategoryViewPresenter: UserModelDelegate { }
