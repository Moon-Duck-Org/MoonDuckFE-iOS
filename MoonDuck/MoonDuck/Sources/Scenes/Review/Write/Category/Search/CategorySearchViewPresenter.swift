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
    func scrollViewWillBeginDragging()
}

class CategorySearchViewPresenter: Presenter, CategorySearchPresenter {
    weak var view: CategorySearchView?
    
    let category: ReviewCategory
    let model: CategoryhSearchModelType
        
    init(with provider: AppServices, category: ReviewCategory) {
        self.category = category
        self.model = CategoryhSearchModel(provider)
        super.init(with: provider)
        self.model.delegate = self
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
        view?.createTouchEvent()
    }
    
    // MARK: - Action
    
}

// MARK: - UITextFieldDelegate
extension CategorySearchViewPresenter {
    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text else { return true }
        model.searchMovie(text)
        return true
    }
    
    func textFieldDidEndEditing(_ text: String?) {
        
    }
    
    func textFieldShouldBeginEditing(_ text: String?) -> Bool {
        view?.isEditingText = true
        return true
    }
}

// MARK: UITableViewDataSource
extension CategorySearchViewPresenter {
    func scrollViewWillBeginDragging() {
        view?.endEditing()
    }
}

// MARK: - CategoryhSearchModelDelegate
extension CategorySearchViewPresenter: CategoryhSearchModelDelegate {
    func categorySearchModel(_ searchModel: CategoryhSearchModel, didChange movieList: [CategorySearchMovie]) {
        view?.reloadTableView()
    }
    
    func categorySearchModel(_ searchModel: CategoryhSearchModel, didRecieve error: Error?) {
        // TODO: 오류 처리
    }
}
