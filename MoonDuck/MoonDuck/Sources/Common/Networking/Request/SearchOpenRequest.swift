//
//  SearchOpenRequest.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieRequest: Codable {
    var key: String = "31263527c9b0f3dba1f669b2990459c4"
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
    var language: String = "ko_KR"
    var includeAdult: Bool = true
    var query: String
    var page: Int?
    
    enum CodingKeys: String, CodingKey {
        case language, query, page
        case includeAdult = "include_adult"
    }
}

struct SearchConcertRequest: Codable {
    var service: String = "3f81b8ccf86145f5bbf954924eeb15bf"
    var stdate: String
    var eddate: String
    var cpage: String
    var rows: String
    var newsql: String = "Y"
    var shprfnmfct: String
}
