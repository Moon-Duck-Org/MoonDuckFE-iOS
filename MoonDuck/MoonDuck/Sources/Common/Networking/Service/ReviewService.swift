//
//  ReviewService.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Alamofire

class ReviewService {
    
    func getReview(request: GetReviewRequest, completion: @escaping (_ succeed: ReviewList?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.getReview(request))
            .responseDecodable { (response: AFDataResponse<GetReviewResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain(), nil)
                case .failure(let error):
                    if let errorData = response.data {
                        do {
                            let decodeError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)
                            let apiError = APIError(error: decodeError)
                            completion(nil, apiError)
                        } catch {
                            completion(nil, APIError.decodingError)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
            }
        
    }
    
    func reviewAll(request: ReviewAllRequest, completion: @escaping (_ succeed: ReviewList?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.reviewAll(request))
            .responseDecodable { (response: AFDataResponse<GetReviewResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain(), nil)
                case .failure(let error):
                    if let errorData = response.data {
                        do {
                            let decodeError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)
                            let apiError = APIError(error: decodeError)
                            completion(nil, apiError)
                        } catch {
                            completion(nil, APIError.decodingError)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
            }
        
    }
    
    func putReview(request: WriteReviewRequest, images: [UIImage]?, completion: @escaping (_ succeed: Review?, _ failed: APIError?) -> Void) {
        uploadMultipartFromData(.putReview(request, images), responseType: ReviewResponse.self) { result in
            switch result {
            case .success(let response):
                let review = response.toDomain()
                completion(review, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
    
    func postReview(request: WriteReviewRequest, images: [UIImage]?, completion: @escaping (_ succeed: Review?, _ failed: APIError?) -> Void) {
        uploadMultipartFromData(.postReview(request, images), responseType: ReviewResponse.self) { result in
            switch result {
            case .success(let response):
                let review = response.toDomain()
                completion(review, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func deleteReview(request: DeleteReviewRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.deleteReview(request))
            .responseDecodable { (response: AFDataResponse<Bool>) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    if let errorData = response.data {
                        do {
                            let decodeError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)
                            let apiError = APIError(error: decodeError)
                            completion(nil, apiError)
                        } catch {
                            completion(nil, APIError.decodingError)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
            }
    }
    
    func reviewDetail(request: ReviewDetailRequest, completion: @escaping (_ succeed: Review?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.reviewDetail(request))
            .responseDecodable { (response: AFDataResponse<ReviewResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain(), nil)
                case .failure(let error):
                    if let errorData = response.data {
                        do {
                            let decodeError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)
                            let apiError = APIError(error: decodeError)
                            completion(nil, apiError)
                        } catch {
                            completion(nil, APIError.decodingError)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
            }
    
    }
    
    private func uploadMultipartFromData<T: Decodable>(_ api: MoonDuckAPI, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let multipartFormData = try api.asMultipartFormData()
            let urlRequest = try api.asURLRequest()
            
            API.session.upload(multipartFormData: { multipartFormData }(), with: urlRequest)
                .responseDecodable(of: responseType) { response in
                    switch response.result {
                    case .success(let decodedResponse):
                        completion(.success(decodedResponse))
                    case .failure:
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
