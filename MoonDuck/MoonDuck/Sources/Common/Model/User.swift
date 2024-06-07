//
//  User.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation

struct JoinUser {
    var deviceId: String
    var nickname: String
}

struct User {
    let id: Int
    let deviceId: String
    var nickname: String
    var all: Int = 0
    var movie: Int = 0
    var book: Int = 0
    var drama: Int = 0
    var concert: Int = 0
}
