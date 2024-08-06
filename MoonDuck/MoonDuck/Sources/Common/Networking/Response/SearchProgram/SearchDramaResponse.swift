//
//  SearchDramaResponse.swift
//  MoonDuck
//
//  Created by suni on 6/17/24.
//

import Foundation

struct SearchDramaResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [ResultItem]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    struct ResultItem: Codable {
        let adult: Bool?
        let backdropPath: String?
        let genreIds: [Int]?
        let id: Int?
        let originCountry: [String]?
        let originalLanguage: String?
        let originalName: String?
        let overview: String?
        let popularity: Double?
        let posterPath: String?
        let firstAirDate: String?
        let name: String?
        let voteAverage: Double?
        let voteCount: Double?
        
        enum CodingKeys: String, CodingKey {
            case adult, id, overview, popularity, name
            case backdropPath = "backdrop_path"
            case genreIds = "genre_ids"
            case originCountry = "origin_country"
            case originalLanguage = "original_language"
            case originalName = "original_name"
            case posterPath = "poster_path"
            case firstAirDate = "first_air_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
        
        func toDomain() -> Program {
            
            let title: String = originalName ?? ""
            
            var genre: String {
                var str = ""
                if let genreIds {
                    let list: [String] = genreIds.map { return self.genre($0) }.filter { $0.isNotEmpty }
                    str = list.toSlashString(max: 2)
                }
                return str
            }
            
            var date: String {
                var str = ""
                if let firstAirDate, firstAirDate.count > 3 {
                    str = String(firstAirDate.prefix(4))
                }
                return str
            }
            
            return Program(category: .drama,
                           title: title,
                           date: date,
                           genre: genre)
        }
        
        // swiftlint:disable cyclomatic_complexity
        private func genre(_ id: Int) -> String {
            switch id {
            case 10759: return "Action & Adventure"
            case 16: return "애니메이션"
            case 35: return "코미디"
            case 80: return "범죄"
            case 99: return "다큐멘터리"
            case 18: return "드라마"
            case 10751: return "가족"
            case 10762: return "Kids"
            case 9648: return "미스터리"
            case 10763: return "News"
            case 10764: return "Reality"
            case 10765: return "Sci-Fi & Fantasy"
            case 10766: return "Soap"
            case 10767: return "Talk"
            case 10768: return "War & Politics"
            case 37: return "서부"
            default: return ""
            }
        }
        // swiftlint:enable cyclomatic_complexity
    }
}
