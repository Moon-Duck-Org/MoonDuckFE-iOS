//
//  ReviewService.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Alamofire

class ReviewService {
    
    func getReview(request: GetReviewRequest, completion: @escaping (_ succeed: ReviewList?, _ failed: Error?) -> Void) {
        MoonDuckAPI.getReview(request).performRequest(responseType: ReviewListResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func reviewAll(request: ReviewAllRequest, completion: @escaping (_ succeed: ReviewList?, _ failed: Error?) -> Void) {
        MoonDuckAPI.reviewAll(request).performRequest(responseType: ReviewListResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
        
    }
    
    func putReview(request: WriteReviewRequest, images: [UIImage]?, completion: @escaping (_ succeed: Review?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.putReview(request, images).uploadMultipartFromData(responseType: ReviewResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
        
    }
    
    func postReview(request: WriteReviewRequest, images: [UIImage]?, completion: @escaping (_ succeed: Review?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.postReview(request, images).uploadMultipartFromData(responseType: ReviewResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func deleteReview(request: DeleteReviewRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        MoonDuckAPI.deleteReview(request).performRequest(responseType: Bool.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func reviewDetail(request: ReviewDetailRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        MoonDuckAPI.reviewDetail(request).performRequest(responseType: ReviewResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    
    }
    
//    private func uploadMultipartFromData<T: Decodable>(_ api: MoonDuckAPI, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
//        do {
//            let multipartFormData = try api.asMultipartFormData()
//            let urlRequest = try api.asURLRequest()
//            
//            API.session.upload(multipartFormData: { multipartFormData }(), with: urlRequest)
//                .responseDecodable(of: responseType) { response in
//                    switch response.result {
//                    case .success(let decodedResponse):
//                        completion(.success(decodedResponse))
//                    case .failure(let error):
//                        if let data = response.data {
//                            do {
//                                let errorResponse = try JSONDecoder().decode(ErrorEntity.self, from: data)
//                                let apiError = APIError(error: errorResponse)
//                                completion(.failure(apiError))
//                            } catch {
//                                completion(.failure(.decodingError))
//                            }
//                        } else {
//                            completion(.failure(.network(code: "\(error.responseCode ?? -99)", message: error.localizedDescription)))
//                        }
//                    }
//                }
//        } catch {
//            completion(.failure(.unowned))
//        }
//    }
}
