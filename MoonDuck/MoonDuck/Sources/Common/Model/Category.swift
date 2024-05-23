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
            return Asset.Assets.all.image
        case .movie:
            return Asset.Assets.movie.image
        case .book:
            return Asset.Assets.book.image
        case .drama:
            return Asset.Assets.drama.image
        case .concert:
            return Asset.Assets.concert.image
        }
    }
}
