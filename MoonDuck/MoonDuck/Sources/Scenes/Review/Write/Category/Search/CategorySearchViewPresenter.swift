//
//  CategorySearchViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import Foundation

protocol CategorySearchPresenter: AnyObject {
    var view: CategorySearchView? { get set }
    
    /// Data
    var numberOfCategories: Int { get }
    
    func category(at index: Int) -> CategorySearchMovie?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action  
    
    /// TextField Delegate
    func textFieldShouldReturn(_ text: String?) -> Bool
    func textFieldDidEndEditing(_ text: String?)
    func textFieldShouldBeginEditing(_ text: String?) -> Bool
}

class CategorySearchViewPresenter: Presenter, CategorySearchPresenter {
    weak var view: CategorySearchView?
    
    let category: ReviewCategory
    let model: CategoryhSearchModelType
    
    init(with provider: AppServices, category: ReviewCategory) {
        self.category = category
        self.model = CategoryhSearchModel(provider)
        super.init(with: provider)
    }
    
    // MARK: - Data
    var numberOfCategories: Int {
        return model.numberOfCategories
    }
    
    func category(at index: Int) -> CategorySearchMovie? {
        if index < model.numberOfCategories {
            return model.categories[index]
        } else {
            return nil
        }
    }
}

extension CategorySearchViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        
    }
    
    // MARK: - Action
    
}

// MARK: - UITextFieldDelegate
extension CategorySearchViewPresenter {
    func textFieldShouldReturn(_ text: String?) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ text: String?) {
        
    }
    
    func textFieldShouldBeginEditing(_ text: String?) -> Bool {
        return true
    }
}
