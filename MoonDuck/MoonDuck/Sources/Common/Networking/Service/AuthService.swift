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
                    completion(nil, error)
                }
            }
    }
}
