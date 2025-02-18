//
//  ReviewList.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

struct ReviewList {
    var category: Category = .none
    var sortOption: Sort = .latestOrder
    var totalElements: Int
    var totalPages: Int
    let size: Int
    var currentPage: Int
    var isFirst: Bool
    var isLast: Bool
    var isEmpty: Bool
    var reviews: [APIReview]
    
    mutating func update(for list: ReviewList) {
        // Update the properties
        self.totalElements = list.totalElements
        self.totalPages = list.totalPages
        self.currentPage = list.currentPage
        self.isFirst = list.isFirst
        self.isLast = list.isLast
        self.isEmpty = list.isEmpty
        
        // Append new reviews to the existing list
        self.reviews.append(contentsOf: list.reviews)
    }
    
    mutating func updateSync(for list: ReviewList, startIndex: Int) {
        // Update the properties
        self.totalElements = list.totalElements
        self.totalPages = list.totalPages
        self.currentPage = list.currentPage
        self.isFirst = list.isFirst
        self.isLast = list.isLast
        self.isEmpty = list.isEmpty
        
        let endIndex = startIndex + list.reviews.count
        if startIndex < self.reviews.count {
            self.reviews.replaceSubrange(startIndex..<min(endIndex, self.reviews.count), with: list.reviews)
            if endIndex > self.reviews.count {
                // 남은 데이터를 추가합니다.
                let remainingData = list.reviews.dropFirst(self.reviews.count - startIndex)
                self.reviews.append(contentsOf: remainingData)
            }
        } else {
            self.reviews.append(contentsOf: list.reviews)
        }
        
        if endIndex < self.reviews.count {
            self.reviews.removeSubrange(endIndex..<self.reviews.count)
        }
    }
}
