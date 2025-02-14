//
//  APIError.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation
import Alamofire

enum APIError: Error, Equatable, LocalizedError {
    // API ERROR
    case error(_ code: String?, _ message: String?)
    case expiredToken(_ code: String?, _ message: String?)
    case invalidToken(_ code: String?, _ message: String?)
    case missingToken(_ code: String?, _ message: String?)
    case missingUser(_ code: String?, _ message: String?)
    case duplicateNickname(_ code: String?, _ message: String?)
    case invalidFilterCondition(_ code: String?, _ message: String?)
    case nonExistentReview(_ code: String?, _ message: String?)
    case invalidProgram(_ code: String?, _ message: String?)
    case fileProcessing(_ code: String?, _ message: String?)
    case imageSizeLimitExceeded(_ code: String?, _ message: String?)
    case revokeTokenGenerationFailed(_ code: String?, _ message: String?)
    case invalidRefreshToken(_ code: String?, _ message: String?)
    
    // Apple API
    case appleApi(_ code: String?, _ message: String?)
    
    // Open API
    case openApi(_ code: String?, _ message: String?)
    case emptySearchData
    
    // ERROR
    case auth
    case network(_ code: String?, _ message: String?)
    case client(_ code: String?, _ message: String?)
    case server(_ code: String?, _ message: String?)
    case decoding
    case unknown
    
    var code: String? {
        switch self {
        case let .error(code, _):
            return code
        case let .expiredToken(code, _):
            return code
        case let .invalidToken(code, _):
            return code
        case let .missingToken(code, _):
            return code
        case let .missingUser(code, _):
            return code
        case let .invalidFilterCondition(code, _):
            return code
        case let .nonExistentReview(code, _):
            return code
        case let .invalidProgram(code, _):
            return code
        case let .fileProcessing(code, _):
            return code
        case let .imageSizeLimitExceeded(code, _):
            return code
        case let .duplicateNickname(code, _):
            return code
        case let .revokeTokenGenerationFailed(code, _):
            return code
        case let .invalidRefreshToken(code, _):
            return code
            
        case let .openApi(code, _):
            return code
        case .emptySearchData:
            return "EMPTY_SEARCH_DATA"
            
        case let .appleApi(code, _):
            return code
            
        case .auth:
            return "AUTH_ERROR"
        case let .network(code, _):
            return code
        case let .client(code, _):
            return code
        case let .server(code, _):
            return code
        case .decoding:
            return "DECODING_ERROR"
        case .unknown:
            return "UNKNOWN"
        }
        
    }
        
    var message: String? {
        switch self {
        case let .error(_, message):
            return message
        case let .expiredToken(_, message):
            return message
        case let .invalidToken(_, message):
            return message
        case let .missingToken(_, message):
            return message
        case let .missingUser(_, message):
            return message
        case let .invalidFilterCondition(_, message):
            return message
        case let .nonExistentReview(_, message):
            return message
        case let .invalidProgram(_, message):
            return message
        case let .fileProcessing(_, message):
            return message
        case let .imageSizeLimitExceeded(_, message):
            return message
        case let .duplicateNickname(_, message):
            return message
        case let .revokeTokenGenerationFailed(_, message):
            return message
        case let .invalidRefreshToken(_, message):
            return message
            
        case let .openApi(_, message):
            return message
        case .emptySearchData:
            return "검색 결과 비어있음"
            
        case let .appleApi(_, message):
            return message
            
        case .auth:
            return "인증 오류 발생"
        case let .network(_, message):
            return message
        case let .client(_, message):
            return message
        case let .server(_, message):
            return message
        case .decoding:
            return "디코딩 오류 발생"
        case .unknown:
            return "알 수 없는 오류 발생"
        }
    }
        
    var isNetworkError: Bool {
        switch self {
        case .network: return true
        default: return false
        }
    }
    var isSystemError: Bool {
        switch self {
        case .client, .server, .decoding, .unknown, .error: return true
        default: return false
        }
    }
    
    var isAuthError: Bool {
        switch self {
        case .invalidToken, .missingToken, .missingUser, .auth, .invalidRefreshToken: return true
        default: return false
        }
    }
    
    var isRevokeTokenError: Bool {
        switch self {
        case .revokeTokenGenerationFailed: return true
        default: return false
        }
    }
    
    var needsTokenRefresh: Bool {
        switch self {
        case .expiredToken: return true
        default: return false
        }
    }
    
    var isReviewError: Bool {
        switch self {
        case .nonExistentReview, .invalidFilterCondition, .fileProcessing, .invalidProgram, .imageSizeLimitExceeded: return true
        default: return false
        }
    }
    
    var imageSizeLimitExceeded: Bool {
        switch self {
        case .imageSizeLimitExceeded:
            return true
        default: return false
        }
    }
    
    var duplicateNickname: Bool {
        switch self {
        case .duplicateNickname:
            return true
        default: return false
        }
    }
    
    var isFailApiLogEvent: Bool {
        switch self {
        case .expiredToken, .duplicateNickname:
            return false
        default: return true
        }
    }
    
    var errorType: APIErrorType {
        switch self {
        case .openApi: return .openApiError
        case .emptySearchData: return .searchConcertError
        case .appleApi: return .appleApiError
        default: return .appError
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    init(error: ErrorEntity) {
        switch error.code {
            // 토큰이 존재하지 않음
        case "AU001": self = .missingToken(error.code, error.message)
            // 만료된 토큰
        case "AU003": self = .expiredToken(error.code, error.message)
            // 유효하지 않은 토큰
        case "AU005": self = .invalidToken(error.code, error.message)
            // Revoke Token 생성 실패
        case "AU007": self = .revokeTokenGenerationFailed(error.code, error.message)
            // 유효하지 않은 Refresh Token
        case "AU008": self = .invalidRefreshToken(error.code, error.message)
            // 존재하지 않는 유저
        case "US001": self = .missingUser(error.code, error.message)
            // 중복된 닉네임
        case "US002": self = .duplicateNickname(error.code, error.message)
            // 존재하지 않는 리뷰
        case "BO001": self = .nonExistentReview(error.code, error.message)
            // 잘못된 필터 조건
        case "BO003": self = .invalidFilterCondition(error.code, error.message)
            // 파일 처리 중 오류
        case "BO004": self = .fileProcessing(error.code, error.message)
            // 유효하지 않은 프로그램
        case "BO005": self = .invalidProgram(error.code, error.message)
            // 이미지 용량 초과
        case "BO006": self = .imageSizeLimitExceeded(error.code, error.message)
        default: self = .error(error.code, error.message)
        }
    }
    // swiftlint:enable cyclomatic_complexity    
    init(statusCode: Int, error: AFError) {
        switch statusCode {
        case 400..<500:
            self = .client("\(statusCode)", error.localizedDescription)
            return
        case 500..<600:
            self = .server("\(statusCode)", error.localizedDescription)
            return
        default: break
        }
        
        if let nsError = error as NSError? {
            switch nsError.code {
            case NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorDNSLookupFailed, NSURLErrorNotConnectedToInternet, NSURLErrorSecureConnectionFailed:
                self = .network("\(nsError.code)", nsError.localizedDescription)
                return
            default: break
            }
        }
        
        if error.isSessionDeinitializedError ||
            error.isSessionInvalidatedError ||
            error.isExplicitlyCancelledError ||
            error.isInvalidURLError ||
            error.isRequestAdaptationError ||
            error.isSessionTaskError {
            self = .network("\(statusCode)", error.localizedDescription)
        } else {
            self = .error("\(statusCode)", error.localizedDescription)
        }
    }
}

struct ErrorEntity: Codable {
    let code: String?
    let message: String?
}
