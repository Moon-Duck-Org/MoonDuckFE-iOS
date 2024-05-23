//
//  MoonDuckAPI.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import Alamofire

enum MoonDuckAPI {
    case user(UserRequest)
}

extension MoonDuckAPI: TargetType {
    
    static func baseUrl() -> String {
        return "http://223.130.162.22:8080/"
    }
    var baseURL: URL {
        switch self {
        default:
            return URL(string: MoonDuckAPI.baseUrl())!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        }
    }

    var path: String {
        switch self {
        case .user:
            return "/user"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .user(let request):
            return .body(request)
            
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        /* 아래와 같이도 사용 가능.
         case .sendChatData:
         return URLEncoding.httpBody
         */
        switch self {
        default:
            return URLEncoding.default
        }
    }
}
