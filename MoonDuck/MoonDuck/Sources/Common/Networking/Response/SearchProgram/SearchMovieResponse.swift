//
//  SearchMovieResponse.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieResponse: Codable {
    let movieListResult: MovieListResult
    
    struct MovieListResult: Codable {
        let totCnt: Int
        let source: String
        let movieList: [Movie]
        
    }
    
    struct Movie: Codable {
        let movieCd: String?
        let movieNm: String
        let movieNmEn: String?
        let prdtYear: String?
        let openDt: String?
        let typeNm: String?
        let prdtStatNm: String?
        let nationAlt: String?
        let genreAlt: String?
        let repNationNm: String?
        let repGenreNm: String?
        let directors: [Director]?
        let companys: [Company?]?
        
        func toDomain() -> ReviewProgram {
            
            var director: String {
                var str = ""
                if let directors {
                    let list = directors.map { $0.peopleNm }
                    str = list.toSlashString(max: 2)
                }
                return str
            }
            
            var genre: String {
                var str = ""
                if let genreAlt {
                    var arr: [String] = []
                    let arrGenre = genreAlt.split(separator: "/").map { String($0) }
                    for genre in arrGenre {
                        let item = genre.split(separator: ",").map { String($0) }
                        arr.append(contentsOf: item)
                    }
                    
                    str = arr.toSlashString(max: 2)
                }
                return str
            }
            
            var date: String {
                var str = ""
                if let openDt, openDt.count > 3 {
                    str = String(openDt.prefix(4))
                }
                return str
            }
            
            return ReviewProgram(programType: .movie,
                                 title: movieNm,
                                 date: date,
                                 genre: genre,
                                 director: director)
        }
    }
    struct Director: Codable {
        let peopleNm: String
    }
    
    struct Company: Codable {
        let companyCd: String
        let companyNm: String
    }
}
