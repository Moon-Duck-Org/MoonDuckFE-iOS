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
    var numberOfCategories: Int { get }
    var categories: [CategorySearchMovie] { get }
    
    func searchMovie(_ movie: String)
}

class CategoryhSearchModel: CategoryhSearchModelType {
    
    weak var delegate: CategoryhSearchModelDelegate?
    
    private let provider: AppServices
    
    var currentPage: Int = 0
    var itemPerPage: Int = 30
    var searchList: [CategorySearchMovie] = []
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    var numberOfCategories: Int {
        return searchList.count
    }
    
    var categories: [CategorySearchMovie] {
        return searchList
    }
    
    private func save(list: [CategorySearchMovie]) {
        searchList.append(contentsOf: list)
        delegate?.categorySearchModel(self, didChange: searchList)
    }
    
    // MARK: - Networking
    func searchMovie(_ movie: String) {
        let request = SearchMovieRequest(curPage: "\(currentPage)", itemPerPage: "\(itemPerPage)", movieNm: movie)
        provider.categorySearchService.movie(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.save(list: succeed)
            } else {
                // 오류 발생
            }
        }
    }
}
