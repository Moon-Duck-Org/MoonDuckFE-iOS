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
    
    func exit(completion: @escaping (_ succeed: ExitResponse?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.exit.performRequest(responseType: ExitResponse.self, completion: {  result in
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
    
    func revokeToken(request: RevokeTokenRequest, completion: @escaping (_ succeed: String?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.revokeToken(request).performRequest(responseType: RevokeTokenResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.revokeToken, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func revokeApple(request: RevokeAppleRequest, completion: @escaping (_ succeed: Bool?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.revokeApple(request).performRequest(responseType: Data.self, completion: {  result in
            switch result {
            case .success:
                completion(true, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func appleToken(request: AppleTokenRequest, completion: @escaping (_ succeed: AppleTokenResponse?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.appleToken(request).performRequest(responseType: AppleTokenResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
