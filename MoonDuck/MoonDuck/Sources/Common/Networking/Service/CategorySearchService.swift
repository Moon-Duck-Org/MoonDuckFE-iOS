//
//  CategorySearchService.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Alamofire

class CategorySearchService {
    func movie(request: SearchMovieRequest, completion: @escaping (_ succeed: [CategorySearchMovie]?, _ failed: Error?) -> Void) {
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
}
