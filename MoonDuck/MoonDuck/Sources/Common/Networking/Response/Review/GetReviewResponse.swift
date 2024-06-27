//
//  GetReviewResponse.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

struct GetReviewResponse: Codable {
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let content: [ReviewResponse]?
    let number: Int
    let sort: Sort
    let pageable: Pageable
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
    
    struct Sort: Codable {
        let empty: Bool
        let sorted: Bool
        let unsorted: Bool
    }
    
    struct Pageable: Codable {
        let offset: Int
        let sort: Sort
        let pageNumber: Int
        let pageSize: Int
        let paged: Bool
        let unpaged: Bool
    }
    
    func toDomain() -> ReviewList {
        var reviews: [Review] = []
        if let content {
            reviews = content.map { $0.toDomain() }
        }
        
        return ReviewList(totalElements: totalElements,
                          totalPages: totalPages,
                          size: size,
                          currentPage: number,
                          isFirst: first,
                          isLast: last,
                          isEmpty: empty,
                          reviews: reviews)
    }
}
