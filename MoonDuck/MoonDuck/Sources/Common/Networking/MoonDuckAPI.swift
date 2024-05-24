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
    case userLogin(UserLoginRequest)
    case userNickname(UserNicknameRequest)
}

class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}
extension MoonDuckAPI: TargetType {
    
    static func baseUrl() -> String {
        return "http://223.130.162.22:8080"
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
        case .userLogin:
            return .post
        case .userNickname:
            return .put
        }
    }

    var path: String {
        switch self {
        case .user:
            return "/user"
        case .userLogin:
            return "/user/login"
        case .userNickname:
            return "/user/nickname"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .user(let request):
            return .query(request)
        case .userLogin(let request):
            return .body(request)
        case .userNickname(let request):
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
