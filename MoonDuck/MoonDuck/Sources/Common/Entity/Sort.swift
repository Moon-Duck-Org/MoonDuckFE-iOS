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
            return L10n.Localizable.Sort.latestOrder
        case .ratingOrder:
            return L10n.Localizable.Sort.ratingOrder
        case .oldestFirst:
            return L10n.Localizable.Sort.oldestFirst
        }
    }
}
