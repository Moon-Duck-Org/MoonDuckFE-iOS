//
//  ProgramSearchTableViewCell.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import UIKit

class ProgramSearchTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
        
    func configure(with program: ReviewProgram) {
        titleLabel.text = program.title
        
        switch program.programType {
        case .movie:
            configureMovie(with: program)
        case .book:
            configureBook(with: program)
        case .drama:
            configureDrama(with: program)
        default:
            subTitleLabel.text = ""
        }
    }
    
    private func configureMovie(with program: ReviewProgram) {
        
        var subTitle: String = ""
        if let director = program.director, director.isNotEmpty {
            subTitle += subTitle.isEmpty ? director : " · \(director)"
        }
        if let genre = program.genre, genre.isNotEmpty {
            subTitle += subTitle.isEmpty ? genre : " · \(genre)"
        }
        if let date = program.date, date.isNotEmpty {
            subTitle += subTitle.isEmpty ? date : " · \(date)"
        }
        subTitleLabel.text = subTitle
    }
    
    private func configureBook(with program: ReviewProgram) {
        
        var subTitle: String = ""
        if let director = program.director, director.isNotEmpty {
            subTitle += subTitle.isEmpty ? director : " · \(director)"
        }
        if let publisher = program.publisher, publisher.isNotEmpty {
            subTitle += subTitle.isEmpty ? publisher : " · \(publisher)"
        }
        if let date = program.date, date.isNotEmpty {
            subTitle += subTitle.isEmpty ? date : " · \(date)"
        }
        subTitleLabel.text = subTitle
    }
    
    private func configureDrama(with program: ReviewProgram) {
        
        var subTitle: String = ""
        if let date = program.date, date.isNotEmpty {
            subTitle += subTitle.isEmpty ? date : " · \(date)"
        }
        
        subTitleLabel.text = subTitle
    }
}
