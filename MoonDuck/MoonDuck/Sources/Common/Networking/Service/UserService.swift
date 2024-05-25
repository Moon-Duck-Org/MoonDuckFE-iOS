//
//  UserService.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Alamofire

class UserService {
    func user(request: UserRequest, completion: @escaping (_ succeed: User?, _ failed: Error?) -> Void) {
        
        // FIXME: - TEST CODE
        API.session.request(MoonDuckAPI.user(UserRequest(deviceId: "test")))
//        API.session.request(MoonDuckAPI.user(request))
            .responseDecodable { (response: AFDataResponse<UserResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    func login(request: UserLoginRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.userLogin(request))
            .responseDecodable { (response: AFDataResponse<Bool>) in
                switch response.result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        
//        AF.request(MoonDuckAPI.userLogin(request))
//            .responseDecodable { (response: AFDataResponse<LoginResponse>) in
//                            switch response.result {
//                            case .success(let response):
//                                completion(response.toDomain, nil)
//                            case .failure(let error):
//                                completion(nil, error)
//                            }
//                        }
//                }
    }
    
    func nickname(request: UserNicknameRequest, completion: @escaping (_ succeed: User?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.userNickname(request))
            .responseDecodable { (response: AFDataResponse<UserResponse>) in
                switch response.result {
                case .success(let response):
                    completion(response.toDomain, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
