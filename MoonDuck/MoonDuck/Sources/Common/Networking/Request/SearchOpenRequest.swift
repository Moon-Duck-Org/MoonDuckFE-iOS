//
//  SearchOpenRequest.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct SearchMovieRequest: Encodable {
    let key: String = "31263527c9b0f3dba1f669b2990459c4"
    var curPage: String
    var itemPerPage: String
    var movieNm: String
}
