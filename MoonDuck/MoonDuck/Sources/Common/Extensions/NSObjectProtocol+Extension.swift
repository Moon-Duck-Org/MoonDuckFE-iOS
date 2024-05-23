//
//  NSObjectProtocol+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
