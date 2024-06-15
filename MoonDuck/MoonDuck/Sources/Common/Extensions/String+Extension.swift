//
//  String+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

extension String {
    func toDateString() -> String {
        let date = self.split(separator: "T")[0]
        let str = String(date).split(separator: "-")
        let (year, month, day) = (str[0], str[1], str[2])
        return "\(year)년 \(month)월 \(day)일"
    }
    
    func toBool() -> Bool? {
        if self == "true" {
          return true
        }
        if self == "false" {
          return false
        }
        return nil
      
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
