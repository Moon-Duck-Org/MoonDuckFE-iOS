//
//  APIError.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

enum APIError: Error, Equatable, LocalizedError {
    case network(code: String?, message: String?)
    case expiredToken(_ message: String?)
    case invalidToken(_ message: String?)
    case missingToken(_ message: String?)
    case missingUser(_ message: String?)
    case duplicateNickname(_ message: String?)
    case invalidFilterCondition(_ message: String?)
    case nonExistentReview(_ message: String?)
    case invalidProgram(_ message: String?)
    case fileProcessingError(_ message: String?)
    case decodingError
    case unowned
        
    var errorDescription: String? {
        switch self {
        case let .network(statusCode, message):
            return "ErrorCode: \(statusCode) - Message: \(message ?? "error")"
        case let .expiredToken(message):
            return message
        case let .invalidToken(message):
            return message
        case let .missingToken(message):
            return message
        case let .missingUser(message):
            return message
        case let .duplicateNickname(message):
            return message
        case let .invalidFilterCondition(message):
            return message
        case let .nonExistentReview(message):
            return message
        case let .invalidProgram(message):
            return message
        case let .fileProcessingError(message):
            return message
        case .decodingError:
            return "디코딩 에러 발생"
        case .unowned:
            return "알 수 없는 에러 발생"
        }
    }
    
    var isNetworkError: Bool {
        switch self {
        case .network, .decodingError, .unowned: return true
        default: return false
        }
    }
    
    var isAuthError: Bool {
        switch self {
        case .invalidToken, .missingToken, .missingUser: return true
        default: return false
        }
    }
    
    var needsTokenRefresh: Bool {
        switch self {
        case .expiredToken: return true
        default: return false
        }
    }
    
    var duplicateNickname: Bool {
        switch self {
        case .duplicateNickname: return true
        default: return false
        }
    }
    
    var isReviewError: Bool {
        switch self {
        case .nonExistentReview, .invalidFilterCondition, .fileProcessingError, .invalidProgram: return true
        default: return false
        }
    }
    
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
        case "BO004": self = .fileProcessingError(error.message)
            // 유효하지 않은 프로그램
        case "BO005": self = .invalidProgram(error.message)
        default: self = .network(code: error.code, message: error.message)
        }
    }
}

struct ErrorEntity: Codable {
    let code: String?
    let message: String?
}
