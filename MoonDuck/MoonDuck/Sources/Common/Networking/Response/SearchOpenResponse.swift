//
//  SearchOpenResponse.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieResponse: Decodable {
    let movieCd: String
    let movieNm: String
    let movieNmEn: String
    let prdtYear: String
    let openDt: String
    let typeNm: String
    let prdtStatNm: String
    let nationAlt: String
    let genreAlt: String
    let repNationNm: String
    let repGenreNm: String
    let directors: [Directors]
    let companys: [Companys]
    
    func toDomain() -> CategorySearchMovie {
        return CategorySearchMovie(name: movieNm,
                           openDate: openDt,
                           genres: genreAlt,
                           director: directors[0].peopleNm)
    }
    
    struct Directors: Decodable {
        let peopleNm: String
    }
    
    struct Companys: Decodable {
        let companyCd: String
        let companyNm: String
    }
}
