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
    case authRevokeApple(AuthRevokeAppleRequest)
    case user
    case deleteUser
    case userNickname(UserNicknameRequest)
    case userPush(UserPushRequest)
    case searchMovie(SearchMovieRequest)
    case searchBook(SearchBookRequest)
    case searchDrama(SearchDramaRequest)
    case searchConcert(SearchConcertRequest)
    case postReview(WriteReviewRequest, [UIImage]?)
    case putReview(WriteReviewRequest, [UIImage]?)
    case reviewAll(ReviewAllRequest)
    case getReview(GetReviewRequest)
    case deleteReview(DeleteReviewRequest)
    case reviewDetail(ReviewDetailRequest)
    case getShareUrl(GetShareUrlRequest)
}
extension MoonDuckAPI: TargetType {
    static func baseUrl() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? "https://"
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
        case .authRevokeApple:
            return URL(string: "https://appleid.apple.com")!
        default:
            return URL(string: MoonDuckAPI.baseUrl())!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .searchMovie, .searchBook, .searchDrama, .searchConcert, .reviewAll, .getReview, .reviewDetail, .getShareUrl:
            return .get
        case .authLogin, .authReissue, .authRevokeApple, .postReview:
            return .post
        case .userNickname, .userPush, .putReview:
            return .put
        case .deleteUser, .deleteReview:
            return HTTPMethod.delete
        }
    }

    var path: String {
        switch self {
            // 로그인
        case .authLogin:
            return SecretAPIPath.login
            // access 토큰 재발급
        case .authReissue:
            return SecretAPIPath.reissue
            
            // Apple Login 탈퇴
        case .authRevokeApple:
            return "/auth/revoke"
            
            // User 정보 조회 / 삭제
        case .user, .deleteUser:
            return "/user"
            // User Nickname 수정
        case .userNickname:
            return "/user/nickname"
            // User Push 수정
        case .userPush:
            return "/user/push"
    
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
            
            // Review 전체 리스트
        case .reviewAll:
            return "/api/review/all"
            // Review 리스트/수정/추가/삭제
        case .getReview, .putReview, .postReview, .deleteReview:
            return "/api/review"
            // Review 상세 페이지
        case .reviewDetail:
            return "/api/review/detail"
            
            // 공유 URL 조회
        case let .getShareUrl(request):
            return "/share/getShareUrl/\(request.boardId)"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .authLogin(let request):
            return .body(request)
        case .authReissue(let request):
            return .body(request)
        case .authRevokeApple(let request):
            return .body(request)
        case .user, .deleteUser:
            return nil
        case .userNickname(let request):
            return .body(request)
        case .userPush(let request):
            return .body(request)
        case .searchMovie(let request):
            return .query(request)
        case .searchBook(let request):
            return .query(request)
        case .searchDrama(let request):
            return .query(request)
        case .searchConcert(let request):
            return .query(request)
        case let .postReview(request, images):
            return .multipart(request, images: images)
        case .reviewAll(let request):
            return .query(request)
        case .getReview(let request):
            return .query(request)
        case let .putReview(request, images):
            return .multipart(request, images: images)
        case .deleteReview(let request):
            return .query(request)
        case .reviewDetail(let request):
            return .query(request)
        case .getShareUrl:
            return nil
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
        case .user, .deleteUser, .userNickname, .userPush, .reviewAll, .getReview, .deleteReview, .reviewDetail, .getShareUrl:
            if let token: String = AuthManager.default.getAccessToken() {
                return ["Content-Type": "application/json",
                        "Authorization": "Bearer \(token)"]
            } else {
                return ["Content-Type": "application/json"]
            }
        case .searchBook:
            let apiId = Bundle.main.object(forInfoDictionaryKey: "SearchBookApiId") as? String ?? ""
            let apiKey = Bundle.main.object(forInfoDictionaryKey: "SearchBookApiKey") as? String ?? ""
            return ["X-Naver-Client-Id": apiId,
                    "X-Naver-Client-Secret": apiKey]
        case .searchDrama:
            let apiKey = Bundle.main.object(forInfoDictionaryKey: "SearchDramaApiKey") as? String ?? ""
            return ["accept": "application/json",
                    "Authorization": "Bearer \(apiKey)"]
        case .postReview, .putReview:
            if let token: String = AuthManager.default.getAccessToken() {
                return ["Content-Type": "multipart/form-data",
                        "Authorization": "Bearer \(token)"]
            } else {
                return ["Content-Type": "multipart/form-data"]
            }
        case .authRevokeApple:
            return ["Content-Type": "application/x-www-form-urlencoded"]
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
