//
//  CategoryhSearchModel.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import Foundation

protocol CategoryhSearchModelDelegate: AnyObject {
    func categorySearchModel(_ searchModel: CategoryhSearchModel, didChange movieList: [CategorySearchMovie])
    func categorySearchModel(_ searchModel: CategoryhSearchModel, didRecieve error: Error?)
}

extension CategoryhSearchModelDelegate {
    func categorySearchModel(_ searchModel: CategoryhSearchModel, didRecieve error: Error?) { }
}

protocol CategoryhSearchModelType: AnyObject {
    func searchMovie(_ movie: String)
}

class CategoryhSearchModel: CategoryhSearchModelType {
    
    weak var delegate: CategoryhSearchModelDelegate?
    
    private let provider: AppServices
    
    var currentPage: Int = 0
    var itemPerPage: Int = 30
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    func searchMovie(_ movie: String) {
        
    }
}
