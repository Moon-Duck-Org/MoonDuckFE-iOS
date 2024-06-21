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
    case authReissue(AuthReissueRequest)
    case user
    case userNickname(UserNicknameRequest)
    case searchMovie(SearchMovieRequest)
    case searchBook(SearchBookRequest)
    case searchDrama(SearchDramaRequest)
    case searchConcert(SearchConcertRequest)
    // TODO: - API 수정
    case reviewAll(ReviewAllRequest)
    case getReview(GetReviewRequest)
    case putReview(PutReviewRequest)
    case postReview(PostReviewRequest)
    case deleteReview(DeleteReviewRequest)
    case reviewDetail(ReviewDetailRequest)
}
extension MoonDuckAPI: TargetType {
    static func baseUrl() -> String {
        return "http://moonduck.o-r.kr"
    }
    
    var baseURL: URL {
        switch self {
        case .searchMovie:
            return URL(string: "http://www.kobis.or.kr")!
        case .searchBook:
            return URL(string: "https://openapi.naver.com")!
        case .searchDrama:
            return URL(string: "https://api.themoviedb.org")!
        case .searchConcert:
            return URL(string: "http://openapi.seoul.go.kr:8088")!
        default:
            return URL(string: MoonDuckAPI.baseUrl())!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .searchMovie, .searchBook, .searchDrama, .searchConcert, .reviewAll, .getReview, .reviewDetail:
            return .get
        case .authLogin, .authReissue, .postReview:
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
            // access 토큰 재발급
        case .authReissue:
            return "/auth/reissue"
            // User 정보 조회
        case .user:
            return "/user"
            // User Nickname 수정
        case .userNickname:
            return "/user/nickname"
    
            // Movie Open API
        case .searchMovie:
            return "/kobisopenapi/webservice/rest/movie/searchMovieList.json"
            // Book Open API
        case .searchBook:
            return "/v1/search/book.json"
            // Drama Open API
        case .searchDrama:
            return "/3/search/tv"
            // Concert Open API
        case .searchConcert(let request):
            return "/\(request.key)/\(request.type)/\(request.service)/\(request.startIndex)/\(request.endIndex)/\(request.codename)/\(request.title)/\(request.date)"
            
        case .getReview, .putReview, .postReview, .deleteReview:
            return "/api/review"
        case .reviewAll:
            return "/api/review/all"
        case .reviewDetail:
            return "/api/review/detail"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .authLogin(let request):
            return .body(request)
        case .authReissue(let request):
            return .body(request)
        case .user:
            return nil
        case .userNickname(let request):
            return .body(request)
        case .searchMovie(let request):
            return .query(request)
        case .searchBook(let request):
            return .query(request)
        case .searchDrama(let request):
            return .query(request)
        case .searchConcert:
            return nil
            
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
    
    var headers: HTTPHeaders {
        switch self {
        case .authLogin, .authReissue:
            return ["Content-Type": "application/json"]
        case .user, .userNickname:
            if let token: String = AuthManager.default.getAccessToken() {
                return ["Content-Type": "application/json",
                        "Authorization": "Bearer \(token)"]
            } else {
                return ["Content-Type": "application/json"]
            }
        case .searchBook:
            return ["X-Naver-Client-Id": "FfwMKOMRcT5KZmhvJxYj",
                    "X-Naver-Client-Secret": "JPu7G800Rh"]
        case .searchDrama:
            return ["accept": "application/json",
                    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNjRmZjk2OGEzYTdkMWQ2NjVhNDI2NmIyNzhmMzI0ZiIsInN1YiI6IjY2NmQ0MjA2NmIzYTk0MmQyOGVjMWMwYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uvFajFOjUVv57Xb8onVa0kLT2ZLXtTdYRHkOgalHMmA"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}
