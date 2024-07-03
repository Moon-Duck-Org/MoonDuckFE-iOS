//
//  HomeReviewTableViewCell.swift
//  MoonDuck
//
//  Created by suni on 6/24/24.
//

import UIKit

class HomeReviewTableViewCell: UITableViewCell {
    private var imageDataSource: ReviewImageDataSource?
    private var linkButtonHandler: (() -> Void)?
    private var optionButtonHandler: (() -> Void)?
    
    // @IBOutlet
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
    
    @IBOutlet weak private var linkView: UIView!
    @IBOutlet weak private var linkLabel: UILabel!
    @IBOutlet weak private var linkHeightContraint: NSLayoutConstraint!
    
    @IBAction private func linkButtonTapped(_ sender: Any) {
        linkButtonHandler?()
    }
    
    @IBAction private func optionButtonTapped(_ sender: Any) {
        optionButtonHandler?()
    }
    
    func configure(with review: Review, optionButtonHandler: (() -> Void)? = nil) {
        titleLabel.text = review.title
        dateLabel.text = review.createdAt
        categoryImageview.image = review.category.roundSmallImage
        
        if review.program.title.isNotEmpty {
            programTitleLabel.text = review.program.title
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
        
        imageDataSource = ReviewImageDataSource(review: review)
        imageDataSource?.configure(with: imageCollectionView)
        imageCollectionView.reloadData()
        
        if review.imageUrlList.count > 0 {
            imageCollectionView.isHidden = false
            imageHeightConstraint.constant = 181
        } else {
            imageCollectionView.isHidden = true
            imageHeightConstraint.constant = 0
        }
        
        if let link = review.link, link.isNotEmpty {
            linkLabel.text = link
            linkView.isHidden = false
            linkHeightContraint.constant = 34
            linkButtonHandler = { Utils.openSafariViewController(urlString: link)
            }
        } else {
            linkLabel.text = ""
            linkView.isHidden = true
            linkHeightContraint.constant = 0
            linkButtonHandler = nil
        }
        
        self.optionButtonHandler = optionButtonHandler
    }
}
