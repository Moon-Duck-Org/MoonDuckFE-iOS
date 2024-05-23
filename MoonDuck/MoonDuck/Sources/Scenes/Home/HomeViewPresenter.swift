//
//  HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol HomePresenter: AnyObject {
    var view: HomeView? { get set }
    var numberOfCategory: Int { get }
    func category(at index: Int) -> Category
}

class HomeViewPresenter: HomePresenter {
    weak var view: HomeView?
    
    var numberOfCategory: Int {
        return category.count
    }
    
    private let category: [Category]
    
    init() {
        self.category = [.all, .movie, .book, .drama, .concert]
    }
    
    func category(at index: Int) -> Category {
        return category[index]
    }
}
