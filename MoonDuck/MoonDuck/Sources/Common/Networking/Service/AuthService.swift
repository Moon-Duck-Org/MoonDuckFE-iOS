//
//  AuthService.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Alamofire

class AuthService {
    func login(request: AuthLoginRequest, completion: @escaping (_ succeed: AuthLoginResponse?, _ failed: Error?) -> Void) {
        MoonDuckAPI.authLogin(request).performRequest(responseType: AuthLoginResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }

    func reissue(request: AuthReissueRequest, completion: @escaping (_ succeed: Token?, _ failed: Error?) -> Void) {
        MoonDuckAPI.authReissue(request).performRequest(responseType: AuthReissueResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
