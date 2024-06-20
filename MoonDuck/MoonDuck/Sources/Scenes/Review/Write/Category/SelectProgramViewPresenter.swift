//
//  SelectProgramViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol SelectProgramPresenterDelegate: AnyObject {
    func selectProgam(_ presenter: SelectProgramPresenter, didSuccess program: Program)
    func selectProgamDidCancel(_ presenter: SelectProgramPresenter)
}

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
    func tapNextButton()
    func tapCancelButton()
}

class SelectProgramViewPresenter: Presenter, SelectProgramPresenter {
    weak var view: SelectProgramView?
    private weak var delegate: SelectProgramPresenterDelegate?
    private let categoryModel: CategoryModelType
    
    init(with provider: AppServices,
         categoryModel: CategoryModelType,
         delegate: SelectProgramPresenterDelegate?) {
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
        categoryModel.selectCategory(index)
    }
    
    func tapNextButton() {
        guard let selectedCategory = categoryModel.selectedCategory else { return }
        let model = ProgramSearchModel(provider, category: selectedCategory)
        let presenter = ProgramSearchViewPresenter(with: provider, model: model, delegate: self)
        view?.moveCategorySearch(with: presenter)
    }    
    
    func tapCancelButton() {
        delegate?.selectProgamDidCancel(self)
    }
}

// MARK: - CategoryModelDelegate
extension SelectProgramViewPresenter: CategoryModelDelegate {
    func category(_ reviewCategoryModel: CategoryModel, didChange categories: [Category]) {
        view?.reloadCategories()
    }
    
    func category(_ reviewCategoryModel: CategoryModel, didSelect index: Int?) {
        view?.updateNextButton(index != nil)
        view?.reloadCategories()
    }
}

// MARK: - ProgramSearchPresenterDelegate
extension SelectProgramViewPresenter: ProgramSearchPresenterDelegate {
    func programSearch(_ presenter: ProgramSearchPresenter, didSuccess program: Program) {
        delegate?.selectProgam(self, didSuccess: program)
    }
}
