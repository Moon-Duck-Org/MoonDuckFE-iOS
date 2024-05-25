//
//  ReviewService.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Alamofire

class ReviewService {
    
    func getReview(request: GetReviewRequest, completion: @escaping (_ succeed: [Review]?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.getReview(request))
            .responseDecodable(of: [ReviewResponse].self) { response in
                switch response.result {
                case .success(let response):
                    completion(response.map { $0.toDomain }, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func reviewAll(request: ReviewAllRequest, completion: @escaping (_ succeed: [Review]?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.reviewAll(request))
            .responseDecodable(of: [ReviewResponse].self) { response in
                switch response.result {
                case .success(let response):
                    completion(response.map { $0.toDomain }, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func putReview(request: PutReviewRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.putReview(request))
            .responseDecodable(of: ReviewResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
