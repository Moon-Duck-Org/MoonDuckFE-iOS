//
//  Sort.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

enum Sort: String {
    case latestOrder = "LATEST"
    case ratingOrder = "RATE"
    case oldestFirst = "OLDEST"
    
    var apiKey: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .latestOrder:
            return "최신순"
        case .ratingOrder:
            return "별점순"
        case .oldestFirst:
            return "오래된 순"
        }
    }
}
