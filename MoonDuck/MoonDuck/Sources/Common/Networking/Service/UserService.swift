//
//  UserService.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Alamofire

class UserService {
    func user(completion: @escaping (_ succeed: User?, _ failed: Error?) -> Void) {
        MoonDuckAPI.user.performRequest(responseType: UserResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })

    }
    
    func nickname(request: UserNicknameRequest, completion: @escaping (_ succeed: UserNicknameResponse?, _ failed: Error?) -> Void) {
        MoonDuckAPI.userNickname(request).performRequest(responseType: UserNicknameResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
