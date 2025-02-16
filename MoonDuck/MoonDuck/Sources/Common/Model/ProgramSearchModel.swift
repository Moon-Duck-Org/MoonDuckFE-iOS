//
//  ProgramSearchModel.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import Foundation

protocol ProgramSearchModelDelegate: BaseModelDelegate {
    func programSearchModel(_ model: ProgramSearchModelType, didChange programs: [Program])
    func programSearchDidLast(_ model: ProgramSearchModelType)
}

protocol ProgramSearchModelType: BaseModelType {
    // Data
    var delegate: ProgramSearchModelDelegate? { get set }
    var category: Category { get }
    var lastSearchText: String { get }
    var isLastPrograms: Bool { get }
    var numberOfPrograms: Int { get }
    var programs: [Program] { get }
    
    // Networking
    func search(_ text: String)
    func searchNext()
}

class ProgramSearchModel: ProgramSearchModelType {
    
    private let provider = ProgramSearchService()
    private var isLoading: Bool = false
    
    private var currentPage: Int = 1
    
    init(category: Category) {
        self.category = category
    }
    
    // MARK: - Data
    weak var delegate: ProgramSearchModelDelegate?
    var category: Category
    var lastSearchText: String = ""
    var isLastPrograms: Bool = false
    
    var numberOfPrograms: Int {
        return programs.count
    }
    
    var programs: [Program] = []
    
    // MARK: - Logic
    private func filterPrograms(with category: Category, programs: [Program]) -> [Program] {
        switch category {
        case .movie:
            return programs.filter { $0.genre != "성인물(에로)" }
        default: return programs
        }
    }
    
    // MARK: - Networking
    func search(_ text: String) {
        currentPage = 1
        programs.removeAll()
        
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
            delegate?.error(didRecieve: nil)
        }
    }
    
    func searchNext() {
        currentPage += 1
        switch category {
        case .movie:
            searchMovie(lastSearchText)
        case .book:
            searchBook(lastSearchText)
        case .drama:
            searchDrama(lastSearchText)
        case .concert:
            searchConcert(lastSearchText)
        default:
            delegate?.error(didRecieve: nil)
        }
    }
    
    private func searchConcert(_ concert: String) {
        lastSearchText = concert
        let request = SearchConcertRequest(startIndex: currentPage, endIndex: category.searchSize, title: concert)
        provider.concert(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                if !self.programs.isEmpty && succeed.isEmpty {
                    self.isLastPrograms = true
                    self.delegate?.programSearchDidLast(self)
                } else {
                    self.isLastPrograms = succeed.count < category.searchSize
                    self.programs.append(contentsOf: succeed)
                    self.delegate?.programSearchModel(self, didChange: self.programs)
                }
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    private func searchDrama(_ drama: String) {
        lastSearchText = drama
        let request = SearchDramaRequest(query: drama, page: currentPage)
        provider.drama(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                if !self.programs.isEmpty && succeed.isEmpty {
                    self.isLastPrograms = true
                    self.delegate?.programSearchDidLast(self)
                } else {
                    self.isLastPrograms = succeed.count < category.searchSize
                    self.programs.append(contentsOf: succeed)
                    self.delegate?.programSearchModel(self, didChange: self.programs)
                }
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    private func searchBook(_ book: String) {
        lastSearchText = book
        let request = SearchBookRequest(query: book, display: category.searchSize, start: currentPage)
        provider.book(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                if !self.programs.isEmpty && succeed.isEmpty {
                    self.isLastPrograms = true
                    self.delegate?.programSearchDidLast(self)
                } else {
                    self.isLastPrograms = succeed.count < category.searchSize
                    self.programs.append(contentsOf: succeed)
                    self.delegate?.programSearchModel(self, didChange: self.programs)
                }
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    private func searchMovie(_ movie: String) {
        lastSearchText = movie
        let request = SearchMovieRequest(curPage: "\(currentPage)", itemPerPage: "\(category.searchSize)", movieNm: movie)
        provider.movie(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                if !self.programs.isEmpty && succeed.isEmpty {
                    self.isLastPrograms = true
                    self.delegate?.programSearchDidLast(self)
                } else {
                    self.isLastPrograms = succeed.count < category.searchSize
                    let filterPrograms = self.filterPrograms(with: .movie, programs: succeed)
                    self.programs.append(contentsOf: filterPrograms)
                    self.delegate?.programSearchModel(self, didChange: self.programs)
                }
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
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
