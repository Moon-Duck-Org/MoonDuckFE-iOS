//
//  Date+Extension.swift
//  MoonDuck
//
//  Created by suni on 7/15/24.
//

import Foundation

extension Date {
    /**
     # formatted
     - Author: suni
     - Date: 20.07.15
     - Parameters:
     - format: 변형할 DateFormat
     - Returns: String
     - Note: DateFormat으로 변형한 String 반환
     */
    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self)
    }
}
