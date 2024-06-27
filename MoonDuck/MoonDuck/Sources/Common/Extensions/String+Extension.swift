//
//  String+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

extension String {
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
