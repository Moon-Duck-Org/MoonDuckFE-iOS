//
//  SearchOpenRequest.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieRequest: Encodable {
    let key: String = "31263527c9b0f3dba1f669b2990459c4"
    var curPage: String?
    var itemPerPage: String?
    var movieNm: String?
}

struct SearchBookRequest: Encodable {
    var query: String
    var display: Int?
    var start: Int?
    var sort: String?
}

struct SearchDramaRequest: Encodable {
    let language: String = "ko_KR"
    let include_adult: Bool = true
    var query: String
    var page: Int?
}
