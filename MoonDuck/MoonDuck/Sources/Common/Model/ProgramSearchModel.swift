//
//  ProgramSearchModel.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import Foundation

protocol ProgramSearchModelDelegate: AnyObject {
    func programSearchModel(_ searchModel: ProgramSearchModel, didChange programs: [ReviewProgram])
    func programSearchModel(_ searchModel: ProgramSearchModel, didRecieve error: Error?)
}

extension ProgramSearchModelDelegate {
}

protocol ProgramSearchModelType: AnyObject {
    var delegate: ProgramSearchModelDelegate? { get set }
    var numberOfPrograms: Int { get }
    var programs: [ReviewProgram] { get }
    
    func search(with category: ReviewCategory, title: String)
}

class ProgramSearchModel: ProgramSearchModelType {
    
    weak var delegate: ProgramSearchModelDelegate?
    
    private let provider: AppServices
    
    private var currentPage: Int = 1
    private var itemPerPage: Int = 30
    private var lastSearchText: String = ""
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    var numberOfPrograms: Int {
        return programs.count
    }
    
    var programs: [ReviewProgram] = [] {
        didSet {
            delegate?.programSearchModel(self, didChange: programs)
        }
    }
    
    private func save(_ programs: [ReviewProgram]) {
        self.programs = programs
    }
    
    // MARK: - Networking
    func search(with category: ReviewCategory, title: String) {
        switch category {
        case .movie:
            searchMovie(title)
        case .book:
            searchBook(title)
        default: break
        }
    }
    
    func searchBook(_ book: String) {
        if lastSearchText == book { return }
        lastSearchText = book
        let request = SearchBookRequest(query: book, display: itemPerPage, start: currentPage)
        provider.programSearchService.book(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.save(succeed)
            } else {
                // 오류 발생
                self.delegate?.programSearchModel(self, didRecieve: failed)
            }
        }
    }
    
    func searchMovie(_ movie: String) {
        if lastSearchText == movie { return }
        lastSearchText = movie
        let request = SearchMovieRequest(curPage: "\(currentPage)", itemPerPage: "\(itemPerPage)", movieNm: movie)
        provider.programSearchService.movie(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.save(succeed)
            } else {
                // 오류 발생
                self.delegate?.programSearchModel(self, didRecieve: failed)
            }
        }
    }
}
