//
//  ReviewResponse.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation
import SwiftyJSON

struct ReviewResponse: Codable {
    let id: Int
    let title: String
    let category: String?
    let user: UserResponse?
    let program: ProgramResponse
    let content: String?
    let image1: String?
    let image2: String?
    let image3: String?
    let image4: String?
    let image5: String?
    let url: String?
    let score: Int?
    let createdAt: String?
    
    struct UserResponse: Codable {
        let userId: Int?
        let nickname: String?
    }
    
    struct ProgramResponse: Codable {
        let id: Int?
        let title: String?
        let date: String?
        let genre: String?
        let director: String?
        let actor: String?
        let publisher: String?
        let place: String?
        let price: String?
        
        func toDomain() -> Program {
            return Program(id: id,
                           category: .none,
                           title: title ?? "",
                           date: date,
                           genre: genre,
                           director: director,
                           actor: actor,
                           publisher: publisher,
                           place: place,
                           price: price)
        }
    }
    
    func toDomain() -> Review {
        
        var imageUrlList: [String] = []
        if let image1 {
            imageUrlList.append(image1)
        }
        if let image2 {
            imageUrlList.append(image2)
        }
        if let image3 {
            imageUrlList.append(image3)
        }
        if let image4 {
            imageUrlList.append(image4)
        }
        if let image5 {
            imageUrlList.append(image5)
        }
        
        var created: String {
            var str = ""
            if let createdAt {
                let split = createdAt.split(separator: "T")
                if let date = split.first {
                    str = String(date)
                }
            }
            return str
        }
        
        let domainCategory: Category = Category(rawValue: category ?? "") ?? .none
        
        var domainProgram: Program {
            var program = program.toDomain()
            program.category = domainCategory
            return program
        }
        
        return Review(id: id,
                      title: title,
                      category: domainCategory,
                      user: Review.User(userId: user?.userId ?? 0, nickname: user?.nickname ?? ""),
                      program: domainProgram,
                      content: content ?? "",
                      imageUrlList: imageUrlList,
                      link: url,
                      rating: score ?? 0,
                      createdAt: created)
    }
}
