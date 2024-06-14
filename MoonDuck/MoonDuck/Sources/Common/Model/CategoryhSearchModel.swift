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
}

protocol CategoryhSearchModelType: AnyObject {
    var delegate: CategoryhSearchModelDelegate? { get set }
    var numberOfCategories: Int { get }
    var categories: [CategorySearchMovie] { get }
    
    func searchMovie(_ movie: String)
}

class CategoryhSearchModel: CategoryhSearchModelType {
    
    weak var delegate: CategoryhSearchModelDelegate?
    
    private let provider: AppServices
    
    private var currentPage: Int = 1
    private var itemPerPage: Int = 30
    private var searchList: [CategorySearchMovie] = []
    private var lastSearchText: String = ""
    
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
        searchList = list
        delegate?.categorySearchModel(self, didChange: searchList)
    }
    
    // MARK: - Networking
    func searchMovie(_ movie: String) {
        if lastSearchText == movie { return }
        lastSearchText = movie
        let request = SearchMovieRequest(curPage: "\(currentPage)", itemPerPage: "\(itemPerPage)", movieNm: movie)
        provider.categorySearchService.movie(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.save(list: succeed)
            } else {
                // 오류 발생
                self.delegate?.categorySearchModel(self, didRecieve: failed)
            }
        }
    }
}
