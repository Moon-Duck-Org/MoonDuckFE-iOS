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
    let categoryModel: CategoryModelType
    
    init(with provider: AppServices, categoryModel: CategoryModelType) {
        self.categoryModel = categoryModel
        super.init(with: provider)
        self.categoryModel.delegate = self
    }
    
    // MARK: - Data
    var numberOfCategories: Int {
        return categoryModel.numberOfCategories
    }
    
    var indexOfSelectedCategory: Int? {
        return categoryModel.indexOfSelectedCategory
    }
    
    func category(at index: Int) -> Category? {
        return categoryModel.category(at: index)
    }
}

extension SelectCategoryViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        categoryModel.getCategories(isHaveAll: false)
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        categoryModel.selectCategory(index)
    }
    
    func tapNextButton() {
        guard let selectedCategory = categoryModel.selectedCategory else { return }
        let presenter = ProgramSearchViewPresenter(with: provider, category: selectedCategory)
        view?.moveCategorySearch(with: presenter)
    }    
}

extension SelectCategoryViewPresenter: CategoryModelDelegate {
    func category(_ reviewCategoryModel: CategoryModel, didChange categories: [Category]) {
        view?.reloadCategories()
    }
    
    func category(_ reviewCategoryModel: CategoryModel, didSelect index: Int?) {
        view?.updateNextButton(index != nil)
        view?.reloadCategories()
    }
}
