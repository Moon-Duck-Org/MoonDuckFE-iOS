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
        default:
            subTitleLabel.text = ""
        }
    }
    
    private func configureMovie(with program: ReviewProgram) {
        
        var subTitle: String = ""
        if let genre = program.genre, genre.isNotEmpty {
            subTitle += genre
        }
        if let director = program.director, director.isNotEmpty {
            subTitle += subTitle.isEmpty ? director : " · \(director)"
        }
        if let date = program.date, date.isNotEmpty {
            subTitle += subTitle.isEmpty ? date : " · \(date)"
        }
        subTitleLabel.text = subTitle
    }
    
    private func configureBook(with program: ReviewProgram) {
        
        var subTitle: String = ""
        if let director = program.director, director.isNotEmpty {
            subTitle += director
        }
        if let date = program.date, date.isNotEmpty {
            subTitle += subTitle.isEmpty ? date : " · \(date)"
        }
        subTitleLabel.text = subTitle
    }
}
