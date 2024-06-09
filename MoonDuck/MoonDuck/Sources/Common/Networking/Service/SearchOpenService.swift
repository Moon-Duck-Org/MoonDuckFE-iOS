//
//  SearchOpenService.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Alamofire

class SearchOpenService {
    func searchMovie(request: SearchMovieRequest,completion: @escaping (_ succeed: ReviewMovie?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.searchMovie(request))
            .responseDecodable { (response: AFDataResponse<SearchMovieResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain(), nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
