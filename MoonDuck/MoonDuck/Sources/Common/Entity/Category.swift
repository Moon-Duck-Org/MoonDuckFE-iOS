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
            return Asset.Assets.categoryMovieRoundSmall.image
        case .book:
            return Asset.Assets.categoryBookRoundSmall.image
        case .drama:
            return Asset.Assets.categoryDramaRoundSmall.image
        case .concert:
            return Asset.Assets.categoryConcertRoundSmall.image
        default: return Asset.Assets.imageEmpty.image
        }
    }
    
    var title: String {
        switch self {
        case .all:
            return L10n.Localizable.Category.all
        case .movie:
            return L10n.Localizable.Category.movie
        case .book:
            return L10n.Localizable.Category.book
        case .drama:
            return L10n.Localizable.Category.drama
        case .concert:
            return L10n.Localizable.Category.concert
        case .none:
            return ""
        }
    }
    
    var searchSize: Int {
        switch self {
        case .all:
            return 0
        case .movie:
            return 100
        case .book:
            return 100
        case .drama:
            return 30
        case .concert:
            return 1000
        case .none:
            return 0
        }
    }
    
    func getSamllImageHeight(width: CGFloat = 18) -> CGFloat {
        switch self {
        case .all:
            return 0
        case .movie:
            return width * 51 / 18
        case .book:
            return width * 45 / 18
        case .drama:
            return width * 60 / 18
        case .concert:
            return width * 55 / 18
        case .none:
            return 0
        }
    }
}
