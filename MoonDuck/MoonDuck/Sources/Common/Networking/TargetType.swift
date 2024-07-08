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
                            completion(.failure(apiError))
                        } catch {
                            completion(.failure(.decoding))
                        }
                    } else {
                        let apiError = APIError(statusCode: response.response?.statusCode ?? -99, error: response.error ?? error)
                        completion(.failure(apiError))
                    }
                }
            }
        } catch {
            completion(.failure(.unknown))
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
                                completion(.failure(apiError))
                            } catch {
                                completion(.failure(.decoding))
                            }
                        } else {
                            let apiError = APIError(statusCode: response.response?.statusCode ?? -99, error: response.error ?? error)
                            completion(.failure(apiError))
                        }
                    }
                }
            } catch {
                completion(.failure(.unknown))
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
