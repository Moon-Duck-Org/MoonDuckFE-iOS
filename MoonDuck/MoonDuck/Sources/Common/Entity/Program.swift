//
//  Program.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct Program {
    var id: Int? = nil
    var category: Category
    var title: String
    var date: String? = nil
    var genre: String? = nil
    var director: String? = nil
    var actor: String? = nil
    var publisher: String? = nil
    var place: String? = nil
    var price: String? = nil
    
    var subInfo: String {
        switch self.category {
        case .movie:
            return getMovieInfo(with: self)
        case .book:
            return getBookInfo(with: self)
        case .drama:
            return getDramaInfo(with: self)
        case .concert:
            return getConcertInfo(with: self)
        default:
            return ""
        }
    }
    
    private func getMovieInfo(with program: Program) -> String {
       
        var subInfo: String = ""
        if let director = program.director, director.isNotEmpty {
            subInfo += subInfo.isEmpty ? director : " · \(director)"
        }
        if let genre = program.genre, genre.isNotEmpty {
            subInfo += subInfo.isEmpty ? genre : " · \(genre)"
        }
        if let date = program.date, date.isNotEmpty {
            let strDate = date.prefix(4)
            subInfo += subInfo.isEmpty ? strDate : " · \(strDate)"
        }
        
        return subInfo
    }
    
    private func getBookInfo(with program: Program) -> String {
        
        var subInfo: String = ""
        if let director = program.director, director.isNotEmpty {
            subInfo += subInfo.isEmpty ? director : " · \(director)"
        }
        if let publisher = program.publisher, publisher.isNotEmpty {
            subInfo += subInfo.isEmpty ? publisher : " · \(publisher)"
        }
        if let date = program.date, date.isNotEmpty {
            let strDate = date.prefix(4)
            subInfo += subInfo.isEmpty ? strDate : " · \(strDate)"
        }
        
        return subInfo
    }
    
    private func getDramaInfo(with program: Program) -> String {
        
        var subInfo: String = ""
        if let genre = program.genre, genre.isNotEmpty {
            subInfo += subInfo.isEmpty ? genre : " · \(genre)"
        }
        if let date = program.date, date.isNotEmpty {
            let strDate = date.prefix(4)
            subInfo += subInfo.isEmpty ? strDate : " · \(strDate)"
        }
        return subInfo
    }
    
    private func getConcertInfo(with program: Program) -> String {
        
        var subInfo: String = ""
        if let genre = program.genre, genre.isNotEmpty {
            subInfo += subInfo.isEmpty ? genre : " · \(genre)"
        }
        if let place = program.place, place.isNotEmpty {
            subInfo += subInfo.isEmpty ? place : " · \(place)"
        }
        
        return subInfo
        
    }
}
