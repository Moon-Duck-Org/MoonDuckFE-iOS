//
//  HomeReviewTableViewCell.swift
//  MoonDuck
//
//  Created by suni on 6/24/24.
//

import UIKit

class HomeReviewTableViewCell: UITableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    @IBOutlet weak private var categoryImageview: UIImageView!
    
    @IBOutlet weak private var programTitleLabel: UILabel!
    @IBOutlet weak private var programTitleDot: UILabel!
    
    @IBOutlet weak private var ratingButton1: UIButton!
    @IBOutlet weak private var ratingButton2: UIButton!
    @IBOutlet weak private var ratingButton3: UIButton!
    @IBOutlet weak private var ratingButton4: UIButton!
    @IBOutlet weak private var ratingButton5: UIButton!
    
    @IBOutlet weak private var contentLabel: UILabel!
    
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    @IBOutlet weak private var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var linkLabel: UILabel!
    @IBOutlet weak private var linkHeightContraint: NSLayoutConstraint!
    
    func configure(with review: Review) {
        titleLabel.text = review.title
        dateLabel.text = review.createdAt
        categoryImageview.image = review.category.roundSmallImage
        
        if let program = review.program, program.title.isNotEmpty {
            programTitleLabel.text = program.title
            programTitleDot.isHidden = false
        } else {
            programTitleLabel.text = ""
            programTitleDot.isHidden = true
        }
        
        let rating = review.rating
        ratingButton1.isSelected = rating > 0
        ratingButton2.isSelected = rating > 1
        ratingButton3.isSelected = rating > 2
        ratingButton4.isSelected = rating > 3
        ratingButton5.isSelected = rating > 4
        
        contentLabel.text = review.content
        
        if review.imageUrlList.count > 0 {
            imageCollectionView.isHidden = false
            imageHeightConstraint.constant = 181
        } else {
            imageCollectionView.isHidden = true
            imageHeightConstraint.constant = 0
        }
        
        if let link = review.link, link.isNotEmpty {
            linkLabel.text = link
            linkLabel.isHidden = false
            linkHeightContraint.constant = 48
        } else {
            linkLabel.text = ""
            linkLabel.isHidden = true
            linkHeightContraint.constant = 0
        }
    }
}
