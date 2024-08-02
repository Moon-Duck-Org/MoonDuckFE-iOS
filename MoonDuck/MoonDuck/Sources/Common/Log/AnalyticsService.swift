//
//  AnalyticsService.swift
//  MoonDuck
//
//  Created by suni on 8/2/24.
//

import Foundation

class AnalyticsService {
    static let shared = AnalyticsService()
    
    enum EventCategory {
        case app
    }
    
    enum EventName {
        case OPEN_APP
    }
    
}
