//
//  AuthService.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Alamofire

class AuthService {
    func login(request: LoginRequest, completion: @escaping (_ succeed: LoginResponse?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.login(request).performRequest(responseType: LoginResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }

    func logout(completion: @escaping (_ succeed: LogoutResponse?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.logout.performRequest(responseType: LogoutResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }

    func reissue(request: ReissueRequest, completion: @escaping (_ succeed: Token?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.reissue(request).performRequest(responseType: ReissueResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func revokeApple(request: RevokeAppleRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.revokeApple(request))
            .responseData { response in
                guard let statusCode = response.response?.statusCode else {
                    completion(false, nil)
                    return
                }
                
                switch response.result {
                case .success:
                    if statusCode == 200 {
                        completion(true, nil)
                    } else {
                        completion(false, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
