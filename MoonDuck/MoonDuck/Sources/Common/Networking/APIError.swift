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
    case error(code: String?, message: String?)
    case expiredToken(_ message: String?)
    case invalidToken(_ message: String?)
    case missingToken(_ message: String?)
    case missingUser(_ message: String?)
    case duplicateNickname(_ message: String?)
    case invalidFilterCondition(_ message: String?)
    case nonExistentReview(_ message: String?)
    case invalidProgram(_ message: String?)
    case fileProcessing(_ message: String?)
    case imageSizeLimitExceeded(_ message: String?)

    // ERROR
    case auth
    case network
    case client
    case server
    case decoding
    case unknown
        
    var errorDescription: String? {
        switch self {
        case let .error(code, message):
            return "ErrorCode: \(code ?? "-99") | Message: \(message ?? "unknown")"
        case let .expiredToken(message):
            return message
        case let .invalidToken(message):
            return message
        case let .missingToken(message):
            return message
        case let .missingUser(message):
            return message
        case let .invalidFilterCondition(message):
            return message
        case let .nonExistentReview(message):
            return message
        case let .invalidProgram(message):
            return message
        case let .fileProcessing(message):
            return message
        case let .imageSizeLimitExceeded(message):
            return message
        case let .duplicateNickname(message):
            return message
            
        case .auth:
            return "사용자 인증 오류 발생"
        case .network:
            return "네트워크 오류 발생"
        case .client:
            return "클라이언트 오류 발생"
        case .server:
            return "서버 오류 발생"
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
        case .client, .server, .decoding, .unknown: return true
        default: return false
        }
    }
    
    var isAuthError: Bool {
        switch self {
        case .invalidToken, .missingToken, .missingUser, .auth: return true
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
    
    // swiftlint:disable cyclomatic_complexity
    init(error: ErrorEntity) {
        switch error.code {
            // 토큰이 존재하지 않음
        case "AU001": self = .missingToken(error.message)
            // 만료된 토큰
        case "AU003": self = .expiredToken(error.message)
            // 유효하지 않은 토큰
        case "AU005": self = .invalidToken(error.message)
            // 존재하지 않는 유저
        case "US001": self = .missingUser(error.message)
            // 중복된 닉네임
        case "US002": self = .duplicateNickname(error.message)
            // 존재하지 않는 리뷰
        case "BO001": self = .nonExistentReview(error.message)
            // 잘못된 필터 조건
        case "BO003": self = .invalidFilterCondition(error.message)
            // 파일 처리 중 오류
        case "BO004": self = .fileProcessing(error.message)
            // 유효하지 않은 프로그램
        case "BO005": self = .invalidProgram(error.message)
            // 이미지 용량 초과
        case "BO006": self = .imageSizeLimitExceeded(error.message)
        default: self = .error(code: error.code, message: error.message)
        }
    }
    // swiftlint:enable cyclomatic_complexity    
    init(statusCode: Int, error: AFError) {
        switch statusCode {
        case 400..<500:
            self = .client
            return
        case 500..<600:
            self = .server
            return
        default: break
        }
        
        if let nsError = error as NSError? {
            switch nsError.code {
            case NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorDNSLookupFailed, NSURLErrorNotConnectedToInternet, NSURLErrorSecureConnectionFailed:
                self = .network
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
            self = .network
        } else {
            self = .error(code: "\(statusCode)", message: "\(error.localizedDescription)")
        }
    }
}

struct ErrorEntity: Codable {
    let code: String?
    let message: String?
}
