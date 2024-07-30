//
//  UserService.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Alamofire

class UserService {
    func user(completion: @escaping (_ succeed: User?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.user.performRequest(responseType: UserResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func nickname(request: UserNicknameRequest, completion: @escaping (_ succeed: UserNicknameResponse?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.userNickname(request).performRequest(responseType: UserNicknameResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func push(request: UserPushRequest, completion: @escaping (_ succeed: Bool?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.userPush(request).performRequest(responseType: UserPushResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
