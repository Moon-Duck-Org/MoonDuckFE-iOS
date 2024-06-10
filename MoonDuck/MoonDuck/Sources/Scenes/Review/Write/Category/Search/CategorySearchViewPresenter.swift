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
}

class CategorySearchViewPresenter: Presenter, CategorySearchPresenter {
    weak var view: CategorySearchView?
    
    let category: ReviewCategory?
    
    init(with provider: AppServices, category: ReviewCategory) {
        self.category = category
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
