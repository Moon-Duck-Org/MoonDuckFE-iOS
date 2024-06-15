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
        
    }
    
    func reviewAll(request: ReviewAllRequest, completion: @escaping (_ succeed: [Review]?, _ failed: Error?) -> Void) {
        completion([], nil)
        
    }
    
    func putReview(request: PutReviewRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        completion(Review(id: 0, title: "title", category: .movie, user: .init(userId: 0, nickname: "nickname"), content: "content", imageUrlList: [], score: 5, createdAt: "createdAt"), nil)
        
    }
    
    func postReview(request: PostReviewRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        completion(Review(id: 0, title: "title", category: .movie, user: .init(userId: 0, nickname: "nickname"), content: "content", imageUrlList: [], score: 5, createdAt: "createdAt"), nil)
        
    }
    
    func deleteReview(request: DeleteReviewRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        completion(true, nil)
        
    }
    
    func reviewDetail(request: ReviewDetailRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        completion(Review(id: 0, title: "title", category: .movie, user: .init(userId: 0, nickname: "nickname"), content: "content", imageUrlList: [], score: 5, createdAt: "createdAt"), nil)
    
    }
}
