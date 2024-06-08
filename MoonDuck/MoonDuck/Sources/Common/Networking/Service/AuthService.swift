//
//  AuthService.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

import Alamofire

class AuthService {
    func login(request: AuthLoginRequest, completion: @escaping (_ succeed: AuthLoginResponse?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.authLogin(request))
            .responseDecodable { (response: AFDataResponse<AuthLoginResponse> ) in
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

    func reissue(request: AuthReissueRequest, completion: @escaping (_ succeed: Token?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.authReissue(request))
            .responseDecodable { (response: AFDataResponse<AuthReissueResponse> ) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
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
}
