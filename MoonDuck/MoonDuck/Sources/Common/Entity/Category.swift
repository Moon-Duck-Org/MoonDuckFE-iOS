//
//  Category.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

enum Category: String {
    case all = "ALL"
    case movie = "MOVIE"
    case book = "BOOK"
    case drama = "DRAMA"
    case concert = "CONCERT"
    case none
    
    var apiKey: String {
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
        case .none:
            return Asset.Assets.categoryDefault.image
        }
    }
    
    var grayImage: UIImage {
        switch self {
        case .movie:
            return Asset.Assets.categoryMovieGray.image
        case .book:
            return Asset.Assets.categoryBookGray.image
        case .drama:
            return Asset.Assets.categoryDramaGray.image
        case .concert:
            return Asset.Assets.categoryConcertGray.image
        default: return Asset.Assets.imageEmpty.image
        }
    }
    
    var roundImage: UIImage {
        switch self {
        case .movie:
            return Asset.Assets.categoryMovieRound.image
        case .book:
            return Asset.Assets.categoryBookRound.image
        case .drama:
            return Asset.Assets.categoryDramaRound.image
        case .concert:
            return Asset.Assets.categoryConcertRound.image
        default: return Asset.Assets.imageEmpty.image
        }
    }
    
    var roundSmallImage: UIImage {
        switch self {
        case .movie:
            return Asset.Assets.categoryMovieRound.image
        case .book:
            return Asset.Assets.categoryBookRound.image
        case .drama:
            return Asset.Assets.categoryDramaRound.image
        case .concert:
            return Asset.Assets.categoryConcertRound.image
        default: return Asset.Assets.imageEmpty.image
        }
    }
    
    var title: String {
        switch self {
        case .all:
            return "ALL"
        case .movie:
            return "영화"
        case .book:
            return "책"
        case .drama:
            return "드라마"
        case .concert:
            return "공연"
        case .none:
            return ""
        }
    }
}
