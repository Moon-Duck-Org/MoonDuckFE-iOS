//
//  CategorySearchService.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Alamofire

class ProgramSearchService {
    func movie(request: SearchMovieRequest, completion: @escaping (_ succeed: [ReviewProgram]?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.searchMovie(request))
            .responseDecodable { (response: AFDataResponse<SearchMovieResponse>) in
                switch response.result {
                case .success(let response):
                    let movieList = response.movieListResult.movieList.map { $0.toDomain() }
                    completion(movieList, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func book(request: SearchBookRequest, completion: @escaping (_ succeed: [ReviewProgram]?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.searchBook(request))
            .responseDecodable { (response: AFDataResponse<SearchBookResponse>) in
                switch response.result {
                case .success(let response):
                    let bookList = response.items.map { $0.toDomain() }
                    completion(bookList, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func drama(request: SearchDramaRequest, completion: @escaping (_ succeed: [ReviewProgram]?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.searchDrama(request))
            .responseDecodable { (response: AFDataResponse<SearchDramaResponse>) in
                switch response.result {
                case .success(let response):
                    let bookList = response.results.map { $0.toDomain() }
                    completion(bookList, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func concert(request: SearchConcertRequest, completion: @escaping (_ succeed: String?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.searchConcert(request))
            .responseString { response in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
