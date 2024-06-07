//
//  APIError.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

enum APIError: Error, Equatable, LocalizedError {
    case network(code: String, message: String)
    case expiredToken
    case invalidToken
    case decodingError
    case unowned
    
    var errorDescription: String? {
        switch self {
        case .network(let statusCode, let message):
            return "ErrorCode: \(statusCode)\n Message: \(message)"
        case .expiredToken:
            return "만료된 토큰입니다."
        case .invalidToken:
            return "유효하지 않은 토큰입니다."
        case .decodingError:
            return "디코딩 에러 발생"
        case .unowned:
            return "알 수 없는 에러 발생"
        }
    }
    
    init(error: ErrorEntity) {
        switch error.code {
        case "AU005" : self = .invalidToken
        case "AU003" : self = .expiredToken
        default : self = .network(code: error.code, message: error.message)
        }
    }
}

struct ErrorEntity: Codable {
    let code: String
    let message: String
}
