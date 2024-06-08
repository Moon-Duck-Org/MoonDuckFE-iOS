//
//  UserService.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Alamofire

class UserService {
    func user(completion: @escaping (_ succeed: UserV2?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.user)
            .responseDecodable { (response: AFDataResponse<UserResponse>) in
                switch response.result {
                case .success(let response):
                    Log.debug("rseponse \(response)")
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
    
    func userTest(completion: @escaping (_ succeed: UserV2?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.user)
            .responseDecodable(of: TestUserResponse.self) { response in
                Log.debug(response)
                switch response.result {
                case .success(let response):
                    if let code = response.code {
                        let error = ErrorEntity(code: code, message: response.message)
                        let apiError = APIError(error: error)
                        completion(nil, apiError)
                    } else {
                        completion(response.toDomain, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func nickname(request: UserNicknameRequest, completion: @escaping (_ succeed: UserNicknameResponse?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.userNickname(request))
            .responseDecodable { (response: AFDataResponse<UserNicknameResponse>) in
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
}
