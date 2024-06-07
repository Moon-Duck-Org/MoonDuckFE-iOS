//
//  UserService.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Alamofire

// FIXME: - TEST CODE API
class UserService {
    enum ResultCode: Int {
        case success = 200              // 성공
        case duplicateNickname = 400    // 중복된 닉네임
        case tokenExpiryDate = 403      // 토큰 만료
    }
    
    func user(completion: @escaping (_ code: ResultCode?, _ succeed: UserV2?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.user)
            .responseDecodable { (response: AFDataResponse<UserResponse>) in
                switch response.result {
                case .success(let response):
                    completion(.success, response.toDomain, nil)
                case .failure(let error):
                    completion(ResultCode(rawValue: response.response?.statusCode ?? 0), nil, error)
                }
            }
    }
    
    func nickname(request: UserNicknameRequest, completion: @escaping (_ code: ResultCode?, _ succeed: UserNicknameResponse?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.userNickname(request))
            .responseDecodable { (response: AFDataResponse<UserNicknameResponse>) in
                switch response.result {
                case .success(let response):
                    completion(.success, response, nil)
                case .failure(let error):
                    completion(ResultCode(rawValue: response.response?.statusCode ?? 0), nil, error)
                }
            }
    }
}
