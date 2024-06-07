//
//  Preference.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

class AppUserDefaults {
    /**
     # (E) Key
     - Authors: suni
     - Note: UserDefaults Key 값
     */
    enum Key: String {
        case isAutoLogin
    }
    
    /**
     # getObject
     - parameters:
        - key : 반환할 value의 UserDefaults Key - (E) AppUserDefaults.Key
     - Authors: suni
     - Note: UserDefaults 값을 반환하는 공용 함수
     */
    static func getObject(forKey key: AppUserDefaults.Key) -> Any? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: key.rawValue) {
            return object
        } else {
            return nil
        }
    }
    
    /**
     # set
     - parameters:
        - value : 저장할 값
        - key : 반환할 value의 UserDefaults Key - (E) AppUserDefaults.Key
     - Authors: suni
     - Note: UserDefaults 값을 저장하는 공용 함수
     */
    static func set(_ value: Any?, forKey key: AppUserDefaults.Key) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
}
