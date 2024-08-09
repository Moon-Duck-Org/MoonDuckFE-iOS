//
//  Array+Extensions.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import Foundation

extension Array {
    func toSlashString(max: Int?) -> String {
        var maxCount: Int = self.count
        if let max {
            maxCount = maxCount < max ? maxCount : max
        }
        
        var str: String = ""
        for index in 0..<maxCount {
            str += "\(self[index])"
            
            if index + 1 < maxCount {
                str += "/"
            }
        }
        return str
    }
}
