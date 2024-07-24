//
//  TargetType.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams? { get }
    var headers: HTTPHeaders { get }
}

extension TargetType {
    
    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.headers = headers
        
        if let parameters {
            switch parameters {
            case .query(let request):
                let params = request?.toDictionary() ?? [:]
                let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
                components?.queryItems = queryParams
                urlRequest.url = components?.url
            case .body(let request):
                let params = request?.toDictionary() ?? [:]
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            default: break
            }
        }
        
        return urlRequest
    }
    
    func performRequest<T: Decodable>(responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let urlRequest = try asURLRequest()
            API.session.request(urlRequest).responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let decodedResponse):
                    completion(.success(decodedResponse))
                case .failure(let error):
                    if let data = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorEntity.self, from: data)
                            let apiError = APIError(error: errorResponse)
                            if apiError.needsTokenRefresh {
                                self.refreshTokenAndRetryRequest(responseType: responseType, completion: completion)
                            } else {
                                completion(.failure(apiError))
                            }
                        } catch {
                            completion(.failure(.decoding))
                        }
                    } else {
                        let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                        let error = response.error ?? error
                        let apiError = APIError(statusCode: statusCode, error: error)
                        completion(.failure(apiError))
                    }
                }
            }
        } catch {
            completion(.failure(.unknown))
        }
    }
    
    private func refreshTokenAndRetryRequest<T: Decodable>(responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        AuthManager.shared.refreshToken { success, error in
            if let error {
                // 토큰 재발급 실패 시 오류 반환
                completion(.failure(error))
            }
            if success {
                // 토큰 재발급 성공 시 동일 요청 재시도
                self.performRequest(responseType: responseType, completion: completion)
            } else {
                completion(.failure(APIError.auth))
            }
        }
    }
    
    // 멀티파트 폼 데이터 구성
    func asMultipartFormData() throws -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        
        if let parameters {
            switch parameters {
            case let .multipart(request, images):
                // 이미지를 멀티파트 폼 데이터에 추가
                if let images {
                    for (index, image) in images.enumerated() {
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                        }
                    }
                    Log.network("MultipartFormData success Images --> \(images)")
                }
                
                // JSON 문자열을 멀티파트 폼 데이터에 추가
                let params = request?.toDictionary() ?? [:]
                if let json = try? JSONSerialization.data(withJSONObject: params, options: []) {
                    if let jsonString = String(data: json, encoding: .utf8),
                       let data = jsonString.data(using: .unicode) {
                        multipartFormData.append(data, withName: "boardDto", mimeType: "application/json")
                        Log.network("MultipartFormData success jsonString --> \(jsonString)")
                    }
                }
            default: break
            }
        }
        
        return multipartFormData
    }
    
    func uploadMultipartFromData<T: Decodable>(responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let multipartFormData = try asMultipartFormData()
            let urlRequest = try asURLRequest()
            
            API.session.upload(multipartFormData: { multipartFormData }(), with: urlRequest)
                .responseDecodable(of: responseType) { response in
                    switch response.result {
                    case .success(let decodedResponse):
                        completion(.success(decodedResponse))
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorEntity.self, from: data)
                                let apiError = APIError(error: errorResponse)
                                if apiError.needsTokenRefresh {
                                    self.refreshTokenAndRetryUpload(responseType: responseType, completion: completion)
                                } else {
                                    completion(.failure(apiError))
                                }
                            } catch {
                                completion(.failure(.decoding))
                            }
                        } else {
                            let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                            let error = response.error ?? error
                            let apiError = APIError(statusCode: statusCode, error: error)
                            completion(.failure(apiError))
                        }
                    }
                }
            } catch {
                completion(.failure(.unknown))
            }
    }
    
    private func refreshTokenAndRetryUpload<T: Decodable>(responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        AuthManager.shared.refreshToken { success, error in
            if let error {
                // 토큰 재발급 실패 시 오류 반환
                completion(.failure(error))
            }
            if success {
                // 토큰 재발급 성공 시 동일 요청 재시도
                self.uploadMultipartFromData(responseType: responseType, completion: completion)
            } else {
                completion(.failure(APIError.auth))
            }
        }
    }
    
}

enum RequestParams {
    case query(_ parameter: Codable?)
    case body(_ parameter: Codable?)
    case multipart(_ parameter: Codable?, images: [UIImage]?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
