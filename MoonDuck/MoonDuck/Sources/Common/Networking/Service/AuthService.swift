//
//  AuthService.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Alamofire

class AuthService {
    func login(request: AuthLoginRequest, completion: @escaping (_ succeed: AuthLoginResponse?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.authLogin(request).performRequest(responseType: AuthLoginResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }

    func reissue(request: AuthReissueRequest, completion: @escaping (_ succeed: Token?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.authReissue(request).performRequest(responseType: AuthReissueResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func revokeApple(request: AuthRevokeAppleRequest, completion: @escaping (_ succeed: Bool?, _ failed: Error?) -> Void) {
        API.session.request(MoonDuckAPI.authRevokeApple(request))
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
