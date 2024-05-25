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
    case reviewAll(ReviewAllRequest)
    case getReview(GetReviewRequest)
    case putReview(PutReviewRequest)
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
        return "http://moonduck.o-r.kr"
    }
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: MoonDuckAPI.baseUrl())!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .reviewAll, .getReview:
            return .get
        case .userLogin:
            return .post
        case .userNickname:
            return .put
        case .putReview:
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
        case .getReview, .putReview:
            return "/api/review"
        case .reviewAll:
            return "/api/review/all"
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
        case .getReview(let request):
            return .query(request)
        case .reviewAll(let request):
            return .query(request)
        case .putReview(let request):
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
