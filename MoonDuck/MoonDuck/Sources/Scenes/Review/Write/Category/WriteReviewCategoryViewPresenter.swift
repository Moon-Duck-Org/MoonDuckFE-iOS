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
    func tapNextButton()
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
        return model.getNumberOfCategories(haveAll: false)
    }
    
    var indexOfSelectedCategory: Int? {
        didSet {
            view?.updateNextButton(indexOfSelectedCategory != nil)
        }
    }
    
    func category(at index: Int) -> ReviewCategory? {
        if index < model.getNumberOfCategories(haveAll: false) {
            return model.getCategories(haveAll: false)[index]
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
    
    func tapNextButton() {
        // TODO: - 다음 버튼 탭
    }
    
}

// MARK: - UserModelDelegate
extension WriteReviewCategoryViewPresenter: UserModelDelegate { }
