//
//  HomeReviewTableViewCell.swift
//  MoonDuck
//
//  Created by suni on 6/24/24.
//

import UIKit

class HomeReviewTableViewCell: UITableViewCell {
    private var imageDataSource: HomeReviewImageDataSource?
    private var linkButtonHandler: (() -> Void)?
    private var optionButtonHandler: (() -> Void)?
    
    // @IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var categoryImageview: UIImageView!
    
    @IBOutlet private weak var programTitleLabel: UILabel!
    @IBOutlet private weak var programTitleDot: UILabel!
    
    @IBOutlet private weak var ratingButton1: UIButton!
    @IBOutlet private weak var ratingButton2: UIButton!
    @IBOutlet private weak var ratingButton3: UIButton!
    @IBOutlet private weak var ratingButton4: UIButton!
    @IBOutlet private weak var ratingButton5: UIButton!
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var linkLabel: UILabel!
    @IBOutlet private weak var linkHeightContraint: NSLayoutConstraint!
    
    @IBAction private func linkButtonTapped(_ sender: Any) {
        linkButtonHandler?()
    }
    
    @IBAction private func optionButtonTapped(_ sender: Any) {
        optionButtonHandler?()
    }
    
    func configure(with review: Review, optionButtonHandler: (() -> Void)? = nil, tappedHandler: (() -> Void)? = nil) {
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
        
        imageDataSource = HomeReviewImageDataSource(review: review)
        imageDataSource?.configure(with: imageCollectionView, tappedHandler: tappedHandler)
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
