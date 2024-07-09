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
    
    // 한글 자음 유니코드 범위
    private var hangulConsonantRange: ClosedRange<UInt32> {
        return 12593...12622
    }
    
    // 한글 모음 유니코드 범위
    private var hangulVowelRange: ClosedRange<UInt32> {
        return 12623...12643
    }
    
    // 한글 자음인지 확인
    var isConsonant: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        return hangulConsonantRange.contains(scalar)
    }
    
    // 한글 모음인지 확인
    var isVowel: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        return hangulVowelRange.contains(scalar)
    }
}
