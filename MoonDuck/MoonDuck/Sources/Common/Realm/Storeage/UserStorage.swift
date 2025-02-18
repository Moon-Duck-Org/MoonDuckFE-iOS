//
//  UserStorage.swift
//  MoonDuck
//
//  Created by suni on 2/10/25.
//

import Foundation

class UserStorage {

    private let realm: AppRealm = AppRealm.shared
    
    func nickname() -> String? {
        return AppUserDefaults.getObject(forKey: .nickname) as? String
    }
    
    func isPush() -> Bool {
        return AppUserDefaults.getObject(forKey: .isPush) as? Bool ?? false
    }
    
    func update(nickname: String) {
        AppUserDefaults.set(nickname, forKey: .nickname)
    }
    
    func update(isPush: Bool) {
        AppUserDefaults.set(isPush, forKey: .isPush)
    }
}
