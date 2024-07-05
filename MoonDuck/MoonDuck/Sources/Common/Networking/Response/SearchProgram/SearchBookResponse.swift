//
//  SearchBookResponse.swift
//  MoonDuck
//
//  Created by suni on 6/17/24.
//

import Foundation

struct SearchBookResponse: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
    
//    func toDomain() -> ProgramList {
//        let programs = items.map { $0.toDomain() }
//        return ProgramList(category: .book,
//                           totalElements: total,
//                           size: display,
//                           currentPage: start,
//                           programs: programs)
//    }
    
    struct Item: Codable {
        let title: String
        let link: String?
        let image: String?
        let author: String?
        let discount: String?
        let publisher: String?
        let isbn: String?
        let description: String?
        let pubdate: String?
        
        func toDomain() -> Program {
            
            var director: String {
                var str = ""
                if let author {
                    let list = author.split(separator: "^").map { String($0) }
                    str = list.toSlashString(max: 2)
                }
                return str
            }
            
            var date: String {
                var str = ""
                if let pubdate, pubdate.count > 3 {
                    str = String(pubdate.prefix(4))
                }
                return str
            }
            
            return Program(category: .book,
                           title: title,
                           date: date,
                           director: director,
                           publisher: publisher)
        }
    }
}
