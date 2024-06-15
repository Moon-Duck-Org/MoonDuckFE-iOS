//
//  ReviewResponse.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation
import SwiftyJSON

//struct ReviewResponse: Decodable {
//    struct User: Decodable {
//        let modifiedAt: String?
//        let id: Int
//        let deviceId: String
//        let nickname: String
//        let createdAt: String?
//    }
//    
//    let createdAt: String
//    let modifiedAt: String?
//    let id: Int
//    let title: String
//    let category: String
//    let user: User
//    let content: String
//    let image1: String?
//    let image2: String?
//    let image3: String?
//    let image4: String?
//    let image5: String?
//    let url: String?
//    let score: Int
//}
//
//extension ReviewResponse {
//    var toDomain: Review {
//        var imageUrlList = [String]()
//        if let image1, !image1.isEmpty {
//            imageUrlList.append(image1)
//        }
//        if let image2, !image2.isEmpty {
//            imageUrlList.append(image2)
//        }
//        if let image3, !image3.isEmpty {
//            imageUrlList.append(image3)
//        }
//        if let image4, !image4.isEmpty {
//            imageUrlList.append(image4)
//        }
//        if let image5, !image5.isEmpty {
//            imageUrlList.append(image5)
//        }
//        
//        return Review(id: id,
//                      title: title,
//                      created: createdAt,
//                      nickname: user.nickname,
//                      category: ReviewCategory(rawValue: category) ?? .all,
//                      content: content,
//                      imageUrlList: imageUrlList,
//                      rating: score)
//    }
//}
