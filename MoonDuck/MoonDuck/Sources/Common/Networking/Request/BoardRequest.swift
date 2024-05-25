//
//  BoardRequest.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

struct BoardModifyRequest: Encodable {
    var id: Int
    var category: String
}

struct BoardDelegateRequest: Encodable {
    var id: Int
}

struct BoardPosetUserRequest: Encodable {
    var userId: String
    var category: String
}
