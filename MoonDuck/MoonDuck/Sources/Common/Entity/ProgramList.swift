//
//  ProgramList.swift
//  MoonDuck
//
//  Created by suni on 7/5/24.
//

import Foundation

struct ProgramList {
    var category: Category
    var totalElements: Int? = nil
    var totalPages: Int? = nil
    var size: Int? = nil
    var currentPage: Int? = nil
    var programs: [Program]
}
