//
//  ReviewProgram.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

struct ReviewProgram {
    let programType: ReviewCategory
    let title: String
    var date: String? = nil
    var genre: String? = nil
    var director: String? = nil
    var actor: String? = nil
    var publisher: String? = nil
    var place: String? = nil
    var price: String? = nil
    
    func getSubInfo() -> String {
        switch self.programType {
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
    
    private func getMovieInfo(with program: ReviewProgram) -> String {
       
        var subInfo: String = ""
        if let director = program.director, director.isNotEmpty {
            subInfo += subInfo.isEmpty ? director : " · \(director)"
        }
        if let genre = program.genre, genre.isNotEmpty {
            subInfo += subInfo.isEmpty ? genre : " · \(genre)"
        }
        if let date = program.date, date.isNotEmpty {
            subInfo += subInfo.isEmpty ? date : " · \(date)"
        }
        
        return subInfo
    }
    
    private func getBookInfo(with program: ReviewProgram) -> String {
        
        var subInfo: String = ""
        if let director = program.director, director.isNotEmpty {
            subInfo += subInfo.isEmpty ? director : " · \(director)"
        }
        if let publisher = program.publisher, publisher.isNotEmpty {
            subInfo += subInfo.isEmpty ? publisher : " · \(publisher)"
        }
        if let date = program.date, date.isNotEmpty {
            subInfo += subInfo.isEmpty ? date : " · \(date)"
        }
        
        return subInfo
    }
    
    private func getDramaInfo(with program: ReviewProgram) -> String {
        
        var subInfo: String = ""
        if let date = program.date, date.isNotEmpty {
            subInfo += subInfo.isEmpty ? date : " · \(date)"
        }
        return subInfo
    }
    
    private func getConcertInfo(with program: ReviewProgram) -> String {
        
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
