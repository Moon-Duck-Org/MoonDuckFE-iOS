//
//  ProgramSearchModel.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import Foundation

protocol ProgramSearchModelDelegate: AnyObject {
    func programSearchModel(_ searchModel: ProgramSearchModel, didChange movieList: [ReviewProgramMovie])
    func programSearchModel(_ searchModel: ProgramSearchModel, didRecieve error: Error?)
}

extension ProgramSearchModelDelegate {
}

protocol ProgramSearchModelType: AnyObject {
    var delegate: ProgramSearchModelDelegate? { get set }
    var numberOfPrograms: Int { get }
    var programs: [ReviewProgramMovie] { get }
    
    func searchMovie(_ movie: String)
}

class ProgramSearchModel: ProgramSearchModelType {
    
    weak var delegate: ProgramSearchModelDelegate?
    
    private let provider: AppServices
    
    private var currentPage: Int = 1
    private var itemPerPage: Int = 30
    private var searchList: [ReviewProgramMovie] = []
    private var lastSearchText: String = ""
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    var numberOfPrograms: Int {
        return searchList.count
    }
    
    var programs: [ReviewProgramMovie] {
        return searchList
    }
    
    private func save(list: [ReviewProgramMovie]) {
        searchList = list
        delegate?.programSearchModel(self, didChange: searchList)
    }
    
    // MARK: - Networking
    func searchMovie(_ movie: String) {
        if lastSearchText == movie { return }
        lastSearchText = movie
        let request = SearchMovieRequest(curPage: "\(currentPage)", itemPerPage: "\(itemPerPage)", movieNm: movie)
        provider.programSearchService.movie(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.save(list: succeed)
            } else {
                // 오류 발생
                self.delegate?.programSearchModel(self, didRecieve: failed)
            }
        }
    }
}
