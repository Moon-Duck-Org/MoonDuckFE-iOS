//
//  Sort.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

enum Sort: String {
    case latestOrder = "최신순"
    case ratingOrder = "별점순"
    case oldestFirst = "오래된 순"
    
    var title: String {
        return self.rawValue
    }
}
