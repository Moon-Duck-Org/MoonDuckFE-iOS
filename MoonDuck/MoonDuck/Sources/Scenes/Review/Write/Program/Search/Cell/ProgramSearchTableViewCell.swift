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
        
    func configure(with category: ReviewProgramMovie) {
        titleLabel.text = category.name
        
        var subTitle: String = ""
        if let ganres = category.genres {
            subTitle += ganres
        }
        if let director = category.director {
            subTitle += subTitle.isEmpty ? director : " · \(director)"
        }
        if let openDate = category.openDate {
            subTitle += subTitle.isEmpty ? openDate : " · \(openDate)"
        }
        subTitleLabel.text = subTitle
    }
}
