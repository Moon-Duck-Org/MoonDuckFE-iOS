//
//  ProgramSearchModel.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import Foundation

protocol ProgramSearchModelDelegate: AnyObject {
    func programSearchModel(_ model: ProgramSearchModel, didChange programs: [Program])
    func programSearchModel(_ model: ProgramSearchModel, didRecieve error: Error?)
}

protocol ProgramSearchModelType: AnyObject {
    // Data
    var delegate: ProgramSearchModelDelegate? { get set }
    var category: Category { get }
    var lastSearchText: String { get }
    var numberOfPrograms: Int { get }
    var programs: [Program] { get }
    
    // Networking
    func search(_ text: String)
}

class ProgramSearchModel: ProgramSearchModelType {
    
    private let provider: AppServices
    
    private var currentPage: Int = 1
    private var itemPerPage: Int = 30
    
    var lastSearchText: String = ""
    
    init(_ provider: AppServices,
         category: Category) {
        self.provider = provider
        self.category = category
    }
    
    // MARK: - Data
    weak var delegate: ProgramSearchModelDelegate?
    var category: Category
    
    var numberOfPrograms: Int {
        return programs.count
    }
    
    var programs: [Program] = [] {
        didSet {
            delegate?.programSearchModel(self, didChange: programs)
        }
    }
    
    // MARK: - Logic
    private func save(_ programs: [Program]) {
        self.programs = programs
    }
    
    // MARK: - Networking
    func search(_ text: String) {
        switch category {
        case .movie:
            searchMovie(text)
        case .book:
            searchBook(text)
        case .drama:
            searchDrama(text)
        case .concert:
            searchConcert(text)
        default:
            delegate?.programSearchModel(self, didRecieve: nil)
        }
    }
    
    func searchConcert(_ concert: String) {
        lastSearchText = concert
        let request = SearchConcertRequest(startIndex: currentPage, endIndex: itemPerPage, title: concert)
        provider.programSearchService.concert(request: request) { [weak self]  succeed, failed in
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
    
    func searchDrama(_ drama: String) {
        lastSearchText = drama
        let request = SearchDramaRequest(query: drama, page: currentPage)
        provider.programSearchService.drama(request: request) { [weak self]  succeed, failed in
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
    
    func searchBook(_ book: String) {
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

// - deleted code : 이전 Open API에 사용된 XML Parser
// extension ProgramSearchModel: SearchConcertXMLParserDelegate {
//    func xmlParser(_ parser: SearchConcertXMLParser, didSuccess resList: [SearchConcertResponse]) {
//        let list = resList.map { $0.toDomain() }
//        save(list)
//    }
// }
