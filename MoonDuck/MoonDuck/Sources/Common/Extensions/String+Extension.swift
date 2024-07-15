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
        
        if self == "Y" {
            return true
        }
        
        if self == "N" {
            return false
        }
        
        return nil
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    func toUrlDecode() -> String {
        return self.removingPercentEncoding ?? self
    }
    
    func toBase64Decode() -> String {
        guard let data = Data(base64Encoded: self) else { return self }
        return String(data: data, encoding: .utf8) ?? self
    }
}
