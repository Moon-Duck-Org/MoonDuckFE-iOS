//
//  ReviewList.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

struct ReviewList {
    var category: Category = .none
    var totalPages: Int
    var totalElements: Int
    var currentPage: Int
    var size: Int
    var isFirst: Bool
    var isLast: Bool
    var isEmpty: Bool
    var reviews: [Review]
    
    mutating func update(_ list: ReviewList) {
        // Update the properties
        self.totalPages = list.totalPages
        self.totalElements = list.totalElements
        self.currentPage = list.currentPage
        self.size = list.size
        self.isFirst = list.isFirst
        self.isLast = list.isLast
        self.isEmpty = list.isEmpty
        
        // Append new reviews to the existing list
        self.reviews.append(contentsOf: list.reviews)
    }
}
