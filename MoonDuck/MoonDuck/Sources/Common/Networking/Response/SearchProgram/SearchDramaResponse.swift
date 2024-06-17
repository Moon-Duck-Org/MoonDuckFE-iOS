//
//  SearchDramaResponse.swift
//  MoonDuck
//
//  Created by suni on 6/17/24.
//

import Foundation

struct SearchDramaResponse: Codable {
    let page: Int
    let results: [ResultItem]
    
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
        
        func toDomain() -> ReviewProgram {
            
            let title: String = originalName ?? ""
            
            var date: String {
                var str = ""
                if let firstAirDate, firstAirDate.count > 3 {
                    str = String(firstAirDate.prefix(4))
                }
                return str
            }
            
            return ReviewProgram(programType: .drama,
                                 title: title,
                                 date: date)
        }
    }
}
