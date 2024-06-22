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
        completion(nil, nil)
        
    }
    
    func postReview(request: PostReviewRequest, images: [UIImage]?, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        uploadImagesAndDTO(.postReview(request, images), responseType: ReviewResponse.self) { result in
            switch result {
            case .success(let response):
                Log.debug("rseponse \(response)")
                completion(nil, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
    
    func deleteReview(request: DeleteReviewRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        completion(true, nil)
        
    }
    
    func reviewDetail(request: ReviewDetailRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        completion(nil, nil)
    
    }
    
    func uploadImagesAndDTO<T: Decodable>(_ api: MoonDuckAPI, responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        do {
            let multipartFormData = try api.asMultipartFormData()
            let urlRequest = try api.asURLRequest()
            
            API.session.upload(multipartFormData: { multipartFormData }(), with: urlRequest)
                .responseDecodable(of: responseType) { response in
                    completion(response.result)
                }
        } catch {
            print("Error creating uploadable: \(error)")
            completion(.failure(AFError.explicitlyCancelled))
        }
    }
}
