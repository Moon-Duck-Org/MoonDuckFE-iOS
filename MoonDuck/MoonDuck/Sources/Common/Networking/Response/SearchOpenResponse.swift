//
//  SearchOpenResponse.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieResponse: Decodable {
    let movieListResult: MovieListResult
    
    struct MovieListResult: Decodable {
        let totCnt: Int
        let source: String
        let movieList: [Movie]
        
    }
    
    struct Movie: Decodable {
        let movieCd: String?
        let movieNm: String?
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
        
        func toDomain() -> ReviewProgramMovie {
            let name = movieNm ?? "영화 제목 없음"
            var director: String {
                var str = ""
                if let directors {
                    let list = directors.map { $0.peopleNm }
                    str = list.toSlashString(max: 2)
                }
                return str
            }
            
            return ReviewProgramMovie(name: name,
                                       openDate: openDt,
                                       genres: genreAlt,
                                       director: director)
        }
    }
    struct Director: Decodable {
        let peopleNm: String
    }
    
    struct Company: Decodable {
        let companyCd: String
        let companyNm: String
    }
}
