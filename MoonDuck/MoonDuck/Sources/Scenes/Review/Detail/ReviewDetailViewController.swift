//
//  ReviewDetailViewController.swift
//  MoonDuck
//
//  Created by suni on 6/28/24.
//

import UIKit

protocol ReviewDetailView: BaseView {
    // UI Logic
    func updateData(for review: Review)
    
    // Navigation
    func backToHome()
}

class ReviewDetailViewController: BaseViewController, ReviewDetailView, Navigatable {
    
    var navigator: Navigator?
    let presenter: ReviewDetailPresenter
    private var imageDataSource: ReviewImageDataSource?
    
    // @IBOutlet
    @IBOutlet weak private var categoryImageView: UIImageView!
    @IBOutlet weak private var programTitleLabel: UILabel!
    @IBOutlet weak private var programSubTitleLabel: UILabel!
    
    @IBOutlet weak private var ratingButton1: UIButton!
    @IBOutlet weak private var ratingButton2: UIButton!
    @IBOutlet weak private var ratingButton3: UIButton!
    @IBOutlet weak private var ratingButton4: UIButton!
    @IBOutlet weak private var ratingButton5: UIButton!
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    
    @IBOutlet weak private var linkView: UIView!
    @IBOutlet weak private var linkViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var linkLabel: UILabel!
    
    @IBOutlet weak private var imageView: UIView!
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    @IBOutlet weak private var imageViewHeightConstraint: NSLayoutConstraint!
    
    // @IBAction
    @IBAction private func tapBackButton(_ sender: Any) {
        backToHome()
    }
    @IBAction private func tapOptionButton(_ sender: Any) {
        
    }
    @IBAction private func tapLink(_ sender: Any) {
        
    }
    
    init(navigator: Navigator,
         presenter: ReviewDetailPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: ReviewDetailViewController.className, bundle: Bundle(for: ReviewDetailViewController.self))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self        
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension ReviewDetailViewController {
    func updateData(for review: Review) {
        // 프로그램
        categoryImageView.image = review.category.roundImage
        programTitleLabel.text = review.program.title
        programSubTitleLabel.text = review.program.subInfo
        
        // 데이터
        updateRating(for: review.rating)
        titleLabel.text = review.title
        dateLabel.text = review.createdAt
        contentLabel.text = review.content
        
        if let link = review.link, link.isNotEmpty {
            linkLabel.text = link
            linkView.isHidden = false
            linkViewHeightConstraint.constant = 34
        } else {
            linkLabel.text = ""
            linkView.isHidden = true
            linkViewHeightConstraint.constant = 0
        }
        
        imageDataSource = ReviewImageDataSource(review: presenter.review)
        imageDataSource?.configure(with: imageCollectionView)
        imageCollectionView.reloadData()
        
        if review.imageUrlList.count > 0 {
            imageCollectionView.isHidden = false
            imageViewHeightConstraint.constant = 221
        } else {
            imageCollectionView.isHidden = true
            imageViewHeightConstraint.constant = 0
        }
    }
    
    private func updateRating(for rating: Int) {
        ratingButton1.isSelected = rating > 0
        ratingButton2.isSelected = rating > 1
        ratingButton3.isSelected = rating > 2
        ratingButton4.isSelected = rating > 3
        ratingButton5.isSelected = rating > 4
    }
}

// MARK: - Navigation
extension ReviewDetailViewController {
    func backToHome() {
        navigator?.pop(sender: self, popType: .popToRoot, animated: true)
    }
}
