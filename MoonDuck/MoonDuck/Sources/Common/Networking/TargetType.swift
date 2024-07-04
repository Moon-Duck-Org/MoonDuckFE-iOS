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
                            completion(.failure(.decodingError))
                        }
                    } else {
                        completion(.failure(.network(code: "\(error.responseCode ?? -99)", message: error.localizedDescription)))
                    }
                }
            }
        } catch {
            completion(.failure(.unowned))
        }
    }
    
}

enum RequestParams {
    case query(_ parameter: Codable?)
    case body(_ parameter: Codable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
