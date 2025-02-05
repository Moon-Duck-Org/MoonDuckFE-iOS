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
        
//        func toDomain() -> ProgramList {
//            let programs = movieList.map { $0.toDomain() }
//            return ProgramList(category: .movie,
//                               totalElements: totCnt,
//                               programs: programs)
//        }
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
        
        func toDomain() -> Program {
            
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
                if let openDt {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"

                    if let date = dateFormatter.date(from: openDt) {
                        // 다시 원하는 형식의 문자열로 포맷
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let formattedDate = dateFormatter.string(from: date)
                        str = formattedDate
                    }
                }
                return str
            }
            
            return Program(category: .movie,
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
