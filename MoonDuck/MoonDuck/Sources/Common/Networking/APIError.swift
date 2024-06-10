//
//  APIError.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

enum APIError: Error, Equatable, LocalizedError {
    case network(code: String, message: String?)
    case expiredToken(_ message: String?)
    case invalidToken(_ message: String?)
    case missingToken(_ message: String?)
    case missingUser(_ message: String?)
    case duplicateNickname(_ message: String?)
    case decodingError
    case unowned
        
    var errorDescription: String? {
        switch self {
        case let .network(statusCode, message):
            return "ErrorCode: \(statusCode)\n Message: \(message ?? "error")"
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
    
    init(error: ErrorEntity) {
        switch error.code {
        case "AU001": self = .missingToken(error.message)
        case "AU003": self = .expiredToken(error.message)
        case "AU005": self = .invalidToken(error.message)
        case "US001": self = .missingUser(error.message)
        case "US002": self = .duplicateNickname(error.message)
        default: self = .network(code: error.code, message: error.message)
        }
    }
}

struct ErrorEntity: Decodable {
    let code: String
    let message: String?
}
