//
//  AppKeychain.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation

import SwiftKeychainWrapper

class AppKeychain {
    
    /**
     # set
     - parameters:
        - value : 저장할 값
        - key : 저장할 value의  Key - (E) KeychainWrapper.Key
     - Authors: suni
     - Note: 키체인에 값을 저장하는 공용 함수
     */
    static func set(_ value: String, forKey key: KeychainWrapper.Key) {
        KeychainWrapper.standard.set(value, forKey: key.rawValue)
    }
    
    /**
     # remove
     - parameters:
        - key : 삭제할 value의  Key - (E) Common.KeychainKey
     - Authors: suni
     - Note: 키체인 값을 삭제하는 공용 함수
     */
    static func remove(forKey key: KeychainWrapper.Key) {
        KeychainWrapper.standard.removeObject(forKey: key.rawValue)
    }
    
    /**
     # getValue
     - parameters:
        - key : 반환할 value의 Key - (E) Common.KeychainKey
     - Authors: suni
     - Note: 키체인 값을 반환하는 공용 함수
     */
    static func getValue(forKey key: KeychainWrapper.Key) -> String? {
        return KeychainWrapper.standard.string(forKey: key.rawValue)
    }
}

extension KeychainWrapper.Key {
    static let accessToken: KeychainWrapper.Key = "accessToken"
    static let refreshToken: KeychainWrapper.Key = "refreshToken"
}
