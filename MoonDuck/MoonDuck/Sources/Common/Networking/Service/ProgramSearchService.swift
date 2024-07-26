//
//  CategorySearchService.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Alamofire

class ProgramSearchService {
    func movie(request: SearchMovieRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchMovie(request).performRequest(responseType: SearchMovieResponse.self, completion: { result in
            switch result {
            case .success(let response):
                let movieList = response.movieListResult.movieList.map { $0.toDomain() }
                completion(movieList, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func book(request: SearchBookRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchBook(request).performRequest(responseType: SearchBookResponse.self, completion: { result in
            switch result {
            case .success(let response):
                let bookList = response.items.map { $0.toDomain() }
                completion(bookList, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func drama(request: SearchDramaRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchDrama(request).performRequest(responseType: SearchDramaResponse.self, completion: { result in
            switch result {
            case .success(let response):
                let bookList = response.results.map { $0.toDomain() }
                completion(bookList, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func concert(request: SearchConcertRequest, completion: @escaping (_ succeed: [Program]?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.searchConcert(request).performRequest(responseType: SearchConcertResponse.self, completion: { result in
                switch result {
                case .success(let response):
                    let concertList = response.culturalEventInfo.row.map { $0.toDomain() }
                    completion(concertList, nil)
                case .failure(let error):
                    if error == .emptySearchData {
                        completion([], nil)
                    } else {
                        completion(nil, error)
                    }
                }
            })
    }
}
