//
//  ReviewResponse.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation
import SwiftyJSON

struct ReviewResponse: Decodable {
    struct User: Decodable {
        let modifiedAt: String?
        let id: Int
        let deviceId: String
        let nickname: String
        let createdAt: String?
    }
    
    let createdAt: String
    let modifiedAt: String?
    let id: Int
    let title: String
    let category: String
    let user: User
    let content: String
    let image1: String?
    let image2: String?
    let image3: String?
    let image4: String?
    let image5: String?
    let url: String?
    let score: Int
}
