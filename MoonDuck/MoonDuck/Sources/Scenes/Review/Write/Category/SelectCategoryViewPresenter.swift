//
//  SelectCategoryViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol SelectCategoryPresenter: AnyObject {
    var view: SelectCategoryView? { get set }
    
    /// Data
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    
    func category(at index: Int) -> Category?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func selectCategory(at index: Int)
    func tapNextButton()
}

class SelectCategoryViewPresenter: Presenter, SelectCategoryPresenter {
    weak var view: SelectCategoryView?
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
    
    func category(at index: Int) -> Category? {
        return model.category(at: index)
    }
}

extension SelectCategoryViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        model.getCategories(isHaveAll: false)
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        model.selectCategory(index)
    }
    
    func tapNextButton() {
        guard let selectedCategory = model.selectedCategory else { return }
        let presenter = ProgramSearchViewPresenter(with: provider, category: selectedCategory)
        view?.moveCategorySearch(with: presenter)
    }    
}

extension SelectCategoryViewPresenter: ReviewCategoryModelDelegate {
    func reviewCategoryModel(_ reviewCategoryModel: ReviewCategoryModel, didChange categories: [Category]) {
        view?.reloadCategories()
    }
    
    func reviewCategoryModel(_ reviewCategoryModel: ReviewCategoryModel, didSelect index: Int?) {
        view?.updateNextButton(index != nil)
        view?.reloadCategories()
    }
}
