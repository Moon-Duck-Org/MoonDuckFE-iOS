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
    
    func postReview(request: PostReviewRequest, images: [UIImage]?, completion: @escaping (_ succeed: Review?, _ failed: APIError?) -> Void) {
        uploadMultipartFromData(.postReview(request, images), responseType: ReviewResponse.self) { result in
            switch result {
            case .success(let response):
                Log.debug("rseponse \(response)")
                let review = response.toDomain()
                completion(review, nil)
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
    
    func uploadMultipartFromData<T: Decodable>(_ api: MoonDuckAPI, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let multipartFormData = try api.asMultipartFormData()
            let urlRequest = try api.asURLRequest()
            
            API.session.upload(multipartFormData: { multipartFormData }(), with: urlRequest)
                .responseDecodable(of: responseType) { response in
                    switch response.result {
                    case .success(let decodedResponse):
                        completion(.success(decodedResponse))
                    case .failure(let error):
                        if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorEntity.self, from: data) {
                            let apiError = APIError(error: errorResponse)
                            completion(.failure(apiError))
                        } else {
                            completion(.failure(.unowned))
                        }
                    }
                }
        } catch let error as APIError {
            completion(.failure(error))
        } catch {
            completion(.failure(.unowned))
        }
    }
}
