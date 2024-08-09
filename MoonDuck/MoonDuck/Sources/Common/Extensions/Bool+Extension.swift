//
//  Bool+Extension.swift
//  MoonDuck
//
//  Created by suni on 7/15/24.
//

import Foundation

extension Bool {
    func toYn() -> String {
        return self ? "Y" : "N"
    }
    
    func toString() -> String {
        return self ? "true" : "false"
    }
}
