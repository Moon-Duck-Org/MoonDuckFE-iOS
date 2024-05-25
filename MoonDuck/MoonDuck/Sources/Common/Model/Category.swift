//
//  Category.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

enum Category: String {
    case all = "전체"
    case movie = "영화"
    case book = "책"
    case drama = "드라마"
    case concert = "공연"
    
    var title: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .all:
            return Asset.Assets.categoryAll.image
        case .movie:
            return Asset.Assets.categoryMovie.image
        case .book:
            return Asset.Assets.categoryBook.image
        case .drama:
            return Asset.Assets.categoryDrama.image
        case .concert:
            return Asset.Assets.categoryConcert.image
        }
    }
    
    var apiString: String {
        switch self {
        case .all:
            return "ALL"
        case .movie:
            return "MOVIE"
        case .book:
            return "BOOK"
        case .drama:
            return "DRAMA"
        case .concert:
            return "CONCERT"
        }
    }
}
