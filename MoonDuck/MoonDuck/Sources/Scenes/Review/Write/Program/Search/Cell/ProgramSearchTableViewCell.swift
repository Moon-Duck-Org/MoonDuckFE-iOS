//
//  ProgramSearchTableViewCell.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import UIKit

class ProgramSearchTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
        
    func configure(with program: Program) {
        titleLabel.text = program.title
        subTitleLabel.text = program.getSubInfo()
    }
}
