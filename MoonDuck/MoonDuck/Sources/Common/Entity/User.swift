//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation

// MARK: - API Version
struct User {
    var userId: Int = 0
    var nickname: String?
    
    // API 통신 제거 이후, 미사용
    var all: Int = 0
    var movie: Int = 0
    var book: Int = 0
    var drama: Int = 0
    var concert: Int = 0
    var isPush: Bool = false
}
