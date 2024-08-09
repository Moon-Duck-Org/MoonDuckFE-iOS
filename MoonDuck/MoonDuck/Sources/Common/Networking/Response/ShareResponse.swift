//
//  ShareResponse.swift
//  MoonDuck
//
//  Created by suni on 7/15/24.
//

import Foundation

struct GetShareUrlResponse: Codable {
    let url: String
    
    func toDomain() -> String {
        return self.url
    }
}
