//
//  Review.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

struct Review {
    let id: Int
    var title: String
    var category: Category
    let user: User
    var program: Program?
    var content: String
    var imageUrlList: [String]
    var url: String?
    var score: Int
    let createdAt: String
    
    func getImageList() -> [UIImage] {
        return [Asset.Assets.imageEmptyHome.image,
                Asset.Assets.imageEmptyHome.image,
                Asset.Assets.imageEmptyHome.image,
                Asset.Assets.imageEmptyHome.image,
                Asset.Assets.imageEmptyHome.image]
    }
    
    func getImage(at index: Int) -> UIImage? {
        let list = getImageList()
        if list.count > index {
            return list[index]
        } else {
            return nil
        }
    }
    
    struct User {
        let userId: Int
        let nickname: String
    }
    
    struct Program {
        let id: Int
        let title: String
        let date: String
    }
}
