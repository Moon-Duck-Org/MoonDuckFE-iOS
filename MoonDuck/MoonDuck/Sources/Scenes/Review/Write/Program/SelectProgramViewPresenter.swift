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
    private weak var delegate: WriteReviewPresenterDelegate?
    
    init(with provider: AppStorages,
         model: AppModels,
         delegate: WriteReviewPresenterDelegate?) {
        self.delegate = delegate
        super.init(with: provider, model: model)
        self.model.categoryModel?.delegate = self
    }
    
    // MARK: - Data
    var numberOfCategories: Int {
        return model.categoryModel?.numberOfCategories ?? 0
    }
    
    var indexOfSelectedCategory: Int? {
        return model.categoryModel?.indexOfSelectedCategory
    }
    
    func category(at index: Int) -> Category? {
        return model.categoryModel?.category(at: index)
    }
}

extension SelectProgramViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(.VIEW_WRITE_REVIEW_CATEGORY)
        
        model.categoryModel?.getCategories(isHaveAll: false)
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        model.categoryModel?.selectCategory(at: index)
    }
    
    func nextButtonTapped() {
//        guard let selectedCategory = model.categoryModel?.selectedCategory else { return }
//        let appModel = AppModels(
//            programSearchModel: ProgramSearchModel(provider, category: selectedCategory)
//        )
//        let presenter = ProgramSearchViewPresenter(with: provider, model: appModel, delegate: delegate)
//        view?.moveProgramSearch(with: presenter)
    }
}

// MARK: - CategoryModelDelegate
extension SelectProgramViewPresenter: CategoryModelDelegate {
    func error(didRecieve error: APIError?) {
        
    }
    
    func categoryModel(_ reviewCategoryModel: CategoryModelType, didChange categories: [Category]) {
        view?.reloadCategories()
    }
    
    func categoryModel(_ model: CategoryModelType, didSelect category: Category) {
        view?.updateNextButton(true)
        view?.reloadCategories()
    }
}
