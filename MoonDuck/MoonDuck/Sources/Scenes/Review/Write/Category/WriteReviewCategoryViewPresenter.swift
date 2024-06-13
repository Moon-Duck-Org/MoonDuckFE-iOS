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
        self.model.delegate = self
    }
    
    // MARK: - Data
    var numberOfCategories: Int {
        return model.numberOfCategories
    }
    
    var indexOfSelectedCategory: Int? {
        return model.indexOfSelectedCategory
    }
    
    func category(at index: Int) -> ReviewCategory? {
        return model.category(at: index)
    }
}

extension WriteReviewCategoryViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        model.getCategories(isHaveAll: false)
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        model.selectCategory(index)
    }
    
    func tapNextButton() {
        // TODO: - 다음 버튼 탭
        
    }
    
}

extension WriteReviewCategoryViewPresenter: ReviewCategoryModelDelegate {
    func reviewCategoryModel(_ reviewCategoryModel: ReviewCategoryModel, didChange categories: [ReviewCategory]) {
        view?.reloadCategories()
    }
    
    func reviewCategoryModel(_ reviewCategoryModel: ReviewCategoryModel, didSelect index: Int?) {
        view?.updateNextButton(index != nil)
        view?.reloadCategories()
    }
}
