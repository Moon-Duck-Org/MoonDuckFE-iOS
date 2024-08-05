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
    var errorType: ErrorType { get }
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
    
    func performRequest(completion: @escaping (Result<Bool, APIError>) -> Void) {
        do {
            let urlRequest = try asURLRequest()
            API.session.request(urlRequest).response(responseSerializer: EmptyDataResponseSerializer()) { response in
                switch response.result {
                case .success:
                    completion(.success(response.response?.statusCode == 200))
                case .failure(let error):
                    if let data = response.data {
                        do {
                            switch errorType {
                            case .appError:
                                let errorResponse = try JSONDecoder().decode(ErrorEntity.self, from: data)
                                AnalyticsService.shared.logEvent(
                                    .FAIL_API,
                                    parameters: [.API_TYPE: "APP",
                                                 .API_URL: urlRequest.url ?? "",
                                                 .API_METHOD: urlRequest.httpMethod ?? "",
                                                 .ERROR_CODE: errorResponse.code ?? "",
                                                 .ERROR_MESSAGE: errorResponse.message ?? "",
                                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                )
                                let apiError = APIError(error: errorResponse)
                                completion(.failure(apiError))
                            case .openApiError:
                                let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                                AnalyticsService.shared.logEvent(
                                    .FAIL_API,
                                    parameters: [.API_TYPE: "OPEN",
                                                 .API_URL: urlRequest.url ?? "",
                                                 .API_METHOD: urlRequest.httpMethod ?? "",
                                                 .ERROR_CODE: statusCode,
                                                 .ERROR_MESSAGE: error.localizedDescription,
                                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                )
                                completion(.failure(.openApi))
                            case .appleApiError:
                                let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                                AnalyticsService.shared.logEvent(
                                    .FAIL_API,
                                    parameters: [.API_TYPE: "SNS",
                                                 .API_URL: urlRequest.url ?? "",
                                                 .API_METHOD: urlRequest.httpMethod ?? "",
                                                 .ERROR_CODE: statusCode,
                                                 .ERROR_MESSAGE: error.localizedDescription,
                                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                )
                                completion(.failure(.appleApi))
                            default: completion(.failure(.unknown))
                            }
                            
                        } catch {
                            completion(.failure(.decoding))
                        }
                    } else {
                        let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                        let error = response.error ?? error
                        let apiError = APIError(statusCode: statusCode, error: error)
                        AnalyticsService.shared.logEvent(
                            .FAIL_API,
                            parameters: [.API_TYPE: "UNKNOWN",
                                         .API_URL: urlRequest.url ?? "",
                                         .API_METHOD: urlRequest.httpMethod ?? "",
                                         .ERROR_CODE: statusCode,
                                         .ERROR_MESSAGE: error.localizedDescription,
                                         .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                        )
                        completion(.failure(apiError))
                    }
                }
            }
        } catch {
            completion(.failure(.unknown))
        }
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
                            switch errorType {
                            case .appError:
                                let errorResponse = try JSONDecoder().decode(ErrorEntity.self, from: data)
                                let apiError = APIError(error: errorResponse)
                                if apiError.needsTokenRefresh {
                                    self.refreshTokenAndRetryRequest(responseType: responseType, completion: completion)
                                } else {
                                    AnalyticsService.shared.logEvent(
                                        .FAIL_API,
                                        parameters: [.API_TYPE: "APP",
                                                     .API_URL: urlRequest.url ?? "",
                                                     .API_METHOD: urlRequest.httpMethod ?? "",
                                                     .ERROR_CODE: errorResponse.code ?? "",
                                                     .ERROR_MESSAGE: errorResponse.message ?? "",
                                                     .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                    )
                                    completion(.failure(apiError))
                                }
                            case .searchConcertError:
                                let errorResponse = try JSONDecoder().decode(SearchConcertError.self, from: data)
                                if errorResponse.result.code == "INFO-200" {
                                    completion(.failure(.emptySearchData))
                                } else {
                                    let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                                    AnalyticsService.shared.logEvent(
                                        .FAIL_API,
                                        parameters: [.API_TYPE: "OPEN",
                                                     .API_URL: urlRequest.url ?? "",
                                                     .API_METHOD: urlRequest.httpMethod ?? "",
                                                     .ERROR_CODE: statusCode,
                                                     .ERROR_MESSAGE: error.localizedDescription,
                                                     .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                    )
                                    completion(.failure(.openApi))
                                }
                            case .openApiError:
                                let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                                AnalyticsService.shared.logEvent(
                                    .FAIL_API,
                                    parameters: [.API_TYPE: "OPEN",
                                                 .API_URL: urlRequest.url ?? "",
                                                 .API_METHOD: urlRequest.httpMethod ?? "",
                                                 .ERROR_CODE: statusCode,
                                                 .ERROR_MESSAGE: error.localizedDescription,
                                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                )
                                completion(.failure(.openApi))
                            case .appleApiError:
                                let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                                AnalyticsService.shared.logEvent(
                                    .FAIL_API,
                                    parameters: [.API_TYPE: "SNS",
                                                 .API_URL: urlRequest.url ?? "",
                                                 .API_METHOD: urlRequest.httpMethod ?? "",
                                                 .ERROR_CODE: statusCode,
                                                 .ERROR_MESSAGE: error.localizedDescription,
                                                 .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                )
                                completion(.failure(.appleApi))
                                completion(.failure(.appleApi))
                            }

                        } catch {
                            completion(.failure(.decoding))
                        }
                    } else {
                        let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                        let error = response.error ?? error
                        let apiError = APIError(statusCode: statusCode, error: error)
                        AnalyticsService.shared.logEvent(
                            .FAIL_API,
                            parameters: [.API_TYPE: "UNKNOWN",
                                         .API_URL: urlRequest.url ?? "",
                                         .API_METHOD: urlRequest.httpMethod ?? "",
                                         .ERROR_CODE: statusCode,
                                         .ERROR_MESSAGE: error.localizedDescription,
                                         .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                        )
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
                        if let imageData = image.downscaleTOjpegData(maxBytes: 1_000_000) {
                            multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                            let imageSizeInBytes = imageData.count
                            let imageSizeInKB = Double(imageSizeInBytes) / 1024.0
                            let imageSizeInMB = imageSizeInKB / 1024.0
                            Log.debug("이미지 바이트 체크 \(imageSizeInMB)")
                        }
                    }
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
                                    AnalyticsService.shared.logEvent(
                                        .FAIL_API,
                                        parameters: [.API_TYPE: "APP",
                                                     .API_URL: urlRequest.url ?? "",
                                                     .API_METHOD: urlRequest.httpMethod ?? "",
                                                     .ERROR_CODE: errorResponse.code ?? "",
                                                     .ERROR_MESSAGE: errorResponse.message ?? "",
                                                     .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                                    )
                                    completion(.failure(apiError))
                                }
                            } catch {
                                completion(.failure(.decoding))
                            }
                        } else {
                            let statusCode = response.response?.statusCode ?? response.error?.responseCode ?? error.responseCode ?? -99
                            let error = response.error ?? error
                            let apiError = APIError(statusCode: statusCode, error: error)
                            AnalyticsService.shared.logEvent(
                                .FAIL_API,
                                parameters: [.API_TYPE: "UNKNOWN",
                                             .API_URL: urlRequest.url ?? "",
                                             .API_METHOD: urlRequest.httpMethod ?? "",
                                             .ERROR_CODE: statusCode,
                                             .ERROR_MESSAGE: error.localizedDescription,
                                             .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                            )
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

enum ErrorType {
    case appError
    case searchConcertError
    case openApiError
    case appleApiError
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}

struct EmptyDataResponseSerializer: DataResponseSerializerProtocol {
    public init() {}

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Data? {
        if let error = error { throw error }
        
        guard let data = data, !data.isEmpty else {
            return Data() // or nil based on your requirement
        }
        
        return data
    }
}
