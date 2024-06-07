//
//  MoonDuckAPI.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import Alamofire

enum MoonDuckAPI {
    case authLogin(AuthLoginRequest)
    case user(UserRequest)
    case userNickname(UserNicknameRequest)
    case reviewAll(ReviewAllRequest)
    case getReview(GetReviewRequest)
    case putReview(PutReviewRequest)
    case postReview(PostReviewRequest)
    case deleteReview(DeleteReviewRequest)
    case reviewDetail(ReviewDetailRequest)
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
        case .user, .reviewAll, .getReview, .reviewDetail:
            return .get
        case .authLogin, .postReview:
            return .post
        case .userNickname:
            return .put
        case .putReview:
            return .put
        case .deleteReview:
            return HTTPMethod.delete
        }
    }

    var path: String {
        switch self {
        // 로그인
        case .authLogin:
            return "/auth/login"
        case .user:
            return "/user"
        case .userNickname:
            return "/user/nickname"
        case .getReview, .putReview, .postReview, .deleteReview:
            return "/api/review"
        case .reviewAll:
            return "/api/review/all"
        case .reviewDetail:
            return "/api/review/detail"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .authLogin(let request):
            return .body(request)
        case .user(let request):
            return .query(request)
        case .userNickname(let request):
            return .body(request)
        case .getReview(let request):
            return .query(request)
        case .reviewAll(let request):
            return .query(request)
        case .putReview(let request):
            return .body(request)
        case .postReview(let request):
            return .body(request)
        case .deleteReview(let request):
            return .query(request)
        case .reviewDetail(let request):
            return .query(request)
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
