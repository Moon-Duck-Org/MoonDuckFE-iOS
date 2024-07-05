//
//  SelectProgramViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol SelectProgramPresenter: AnyObject {
    var view: SelectProgramView? { get set }
    
    /// Data
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    
    func category(at index: Int) -> Category?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func selectCategory(at index: Int)
    func nextButtonTapped()
}

class SelectProgramViewPresenter: BaseViewPresenter, SelectProgramPresenter {
    weak var view: SelectProgramView?
    private let categoryModel: CategoryModelType
    private var delegate: WriteReviewPresenterDelegate?
    
    init(with provider: AppServices,
         categoryModel: CategoryModelType,
         delegate: WriteReviewPresenterDelegate?) {
        self.categoryModel = categoryModel
        self.delegate = delegate
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

extension SelectProgramViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        categoryModel.getCategories(isHaveAll: false)
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        categoryModel.selectCategory(at: index)
    }
    
    func nextButtonTapped() {
        guard let selectedCategory = categoryModel.selectedCategory else { return }
        let model = ProgramSearchModel(provider, category: selectedCategory)
        let presenter = ProgramSearchViewPresenter(with: provider, model: model, delegate: delegate)
        view?.moveProgramSearch(with: presenter)
    }
}

// MARK: - CategoryModelDelegate
extension SelectProgramViewPresenter: CategoryModelDelegate {
    func categoryModel(_ reviewCategoryModel: CategoryModel, didChange categories: [Category]) {
        view?.reloadCategories()
    }
    
    func categoryModel(_ model: CategoryModel, didSelect category: Category) {
        view?.updateNextButton(true)
        view?.reloadCategories()
    }
}
