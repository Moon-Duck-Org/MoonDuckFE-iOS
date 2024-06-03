//
//  ReviewService.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Alamofire

class ReviewService {
    
    func getReview(request: GetReviewRequest, completion: @escaping (_ succeed: [Review]?, _ failed: Error?) -> Void) {
        completion([], nil)
        
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
        completion([], nil)
        
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
        completion(Review(id: 0, title: "타이틀", created: "날짜", nickname: "포덕이", category: .movie, content: "내용", imageUrlList: [], rating: 5), nil)
        
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
    
    func postReview(request: PostReviewRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        completion(Review(id: 0, title: "타이틀", created: "날짜", nickname: "포덕이", category: .movie, content: "내용", imageUrlList: [], rating: 5), nil)
        
        API.session.request(MoonDuckAPI.postReview(request))
            .responseDecodable(of: ReviewResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func deleteReview(request: DeleteReviewRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        completion(true, nil)
        
        API.session.request(MoonDuckAPI.deleteReview(request))
            .responseDecodable { (response: AFDataResponse<Bool>) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func reviewDetail(request: ReviewDetailRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        completion(Review(id: 0, title: "타이틀", created: "날짜", nickname: "포덕이", category: .movie, content: "내용", imageUrlList: [], rating: 5), nil)
        
        API.session.request(MoonDuckAPI.reviewDetail(request))
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
