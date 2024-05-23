//
//  UserService.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Alamofire

struct UserService {
    static func user(request: UserRequest, completion: @escaping (_ succeed: User?, _ failed: Error?) -> Void) {
        AF.request(MoonDuckAPI.user(request))
            .responseDecodable { (response: AFDataResponse<UserRseponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}

// TODO: API 사용
//UserService.user(request: UserRequest(deviceId: "")) { succeed, failed in
//    if let succeed {
//        print(succeed)
//    }
//}
