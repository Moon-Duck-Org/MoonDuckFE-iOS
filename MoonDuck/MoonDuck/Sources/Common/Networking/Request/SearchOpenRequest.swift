//
//  SearchOpenRequest.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieRequest: Codable {
    var key: String = Constants.searchMovieKey
    var curPage: String?
    var itemPerPage: String?
    var movieNm: String?
}

struct SearchBookRequest: Codable {
    var query: String
    var display: Int?
    var start: Int?
    var sort: String?
}

struct SearchDramaRequest: Codable {
    var language: String = Constants.appLanguage
    var includeAdult: Bool = false
    var query: String
    var page: Int?
    
    enum CodingKeys: String, CodingKey {
        case language, query, page
        case includeAdult = "include_adult"
    }
}

struct SearchConcertRequest: Codable {
    var key: String = Constants.searchConcertKey
    var type: String = "json"
    var service: String = "culturalEventInfo"
    var startIndex: Int
    var endIndex: Int
    var codename: String = " "
    var title: String
    var date: String = " "
}
