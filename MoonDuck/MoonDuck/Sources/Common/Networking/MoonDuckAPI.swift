//
//  MoonDuckAPI.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import Alamofire

enum MoonDuckAPI {
    case login(LoginRequest)
    case logout
    case exit
    case reissue(ReissueRequest)
    case revokeToken(RevokeTokenRequest)
    case revokeApple(RevokeAppleRequest)
    case appleToken(AppleTokenRequest)
    case user
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
        case .revokeApple, .appleToken:
            return URL(string: "https://appleid.apple.com")!
        default:
            return URL(string: MoonDuckAPI.baseUrl())!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .user, .searchMovie, .searchBook, .searchDrama, .searchConcert, .reviewAll, .getReview, .reviewDetail, .getShareUrl:
            return .get
        case .login, .logout, .reissue, .revokeToken, .revokeApple, .appleToken, .postReview:
            return .post
        case .userNickname, .userPush, .putReview:
            return .put
        case .exit, .deleteReview:
            return HTTPMethod.delete
        }
    }

    var path: String {
        switch self {
            // 로그인
        case .login:
            return SecretAPIPath.login
            // 로그아웃
        case .logout:
            return SecretAPIPath.logout
            // 회원탈퇴
        case .exit:
            return SecretAPIPath.exit
            // access 토큰 재발급
        case .reissue:
            return SecretAPIPath.reissue
        case .revokeToken:
            return SecretAPIPath.revokeToken
            
            // Apple Login 탈퇴
        case .revokeApple:
            return "/auth/revoke"
            // Apple Token 발급
        case .appleToken:
            return "/auth/token"
            
            // User 정보 조회 / 삭제
        case .user:
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
        case .login(let request):
            return .body(request)
        case .logout:
            return nil
        case .exit:
            return nil
        case .reissue(let request):
            return .body(request)
        case .revokeToken(let request):
            return .body(request)
        case .revokeApple(let request):
            return .body(request)
        case .appleToken(let request):
            return .body(request)
        case .user:
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
        case .login, .reissue:
            return ["Content-Type": "application/json"]
        case .logout, .exit, .revokeToken, .user, .userNickname, .userPush, .reviewAll, .getReview, .deleteReview, .reviewDetail, .getShareUrl:
            if let token: String = AuthManager.shared.getAccessToken() {
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
            if let token: String = AuthManager.shared.getAccessToken() {
                return ["Content-Type": "multipart/form-data",
                        "Authorization": "Bearer \(token)"]
            } else {
                return ["Content-Type": "multipart/form-data"]
            }
        case .revokeApple, .appleToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        default:
            return ["Content-Type": "application/json"]
        }
    }    
    
    var errorType: ErrorType {
        switch self {
        case .searchConcert:
            return .searchConcertError
        case .searchBook, .searchDrama, .searchMovie:
            return .openApiError
        case .appleToken, .revokeApple:
            return .appleApiError
        default: return .appError
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
