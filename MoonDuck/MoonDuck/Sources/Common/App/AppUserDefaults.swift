//
//  Preference.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case appReviewRequestCount = "moonduck_appReviewRequestCount"
    case writeReviewCount = "moonduck_writeReviewCount"
    case appOpenCount = "moonduck_appOpenCount"
    case isShowRequestIDAFAuth = "moonduck_isShowRequestIDAFAuth"
    case nickname = "moonduck_nickname"
    case appInstalledAt = "moonduck_appInstalledAt"
    case isPush = "moonduck_isPush"
}

class AppUserDefaults {
    
    /**
     # getObject
     - parameters:
        - key : 반환할 value의 UserDefaults Key - (E) SecretUserDefaultsKeys
     - Authors: suni
     - Note: UserDefaults 값을 반환하는 공용 함수
     */
    static func getObject(forKey key: UserDefaultsKeys) -> Any? {
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
        - key : 저장할 value의 UserDefaults Key - (E) SecretUserDefaultsKeys
     - Authors: suni
     - Note: UserDefaults 값을 저장하는 공용 함수
     */
    static func set(_ value: Any?, forKey key: UserDefaultsKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    /**
     # remove
     - parameters:
        - key : 삭제할 value의 UserDefaults Key - (E) SecretUserDefaultsKeys
     - Authors: suni
     - Note: UserDefaults 값을 삭제하는 공용 함수
     */
    static func remove(forKey key: UserDefaultsKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
    
    // FIXME: API 제거 후 미사용
    static func getObject(forKey key: SecretUserDefaultsKeys) -> Any? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: key.rawValue) {
            return object
        } else {
            return nil
        }
    }
    
    static func set(_ value: Any?, forKey key: SecretUserDefaultsKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func remove(forKey key: SecretUserDefaultsKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
    
}
