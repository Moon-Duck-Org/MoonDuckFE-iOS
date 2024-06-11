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
