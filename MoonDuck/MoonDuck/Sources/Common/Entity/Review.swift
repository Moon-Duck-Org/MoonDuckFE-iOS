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
    let created: String
    let nickname: String
    
    var category: Category
    var content: String
    var imageUrlList: [String]
    var link: String?
    var rating: Int
    
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
}
