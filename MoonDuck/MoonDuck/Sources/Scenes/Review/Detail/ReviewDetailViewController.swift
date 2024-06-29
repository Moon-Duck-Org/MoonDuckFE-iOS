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
    func reloadImages()
    
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
    @IBOutlet weak private var imageViewHeightConstraint: UIView!
    
    // @IBAction
    @IBAction func tapBackButton(_ sender: Any) {
        backToHome()
    }
    @IBAction func tapOptionButton(_ sender: Any) {
        
    }
    @IBAction func tapLink(_ sender: Any) {
        
    }
    
    
    init(navigator: Navigator,
         presenter: ReviewDetailPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.imageDataSource = ReviewImageDataSource(review: presenter.review)
        super.init(nibName: ReviewDetailViewController.className, bundle: Bundle(for: ReviewDetailViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - UI Logic
extension ReviewDetailViewController {
    func updateData(for review: Review) {
        
    }
    
    func reloadImages() {
        
    }
}

// MARK: - Navigation
extension ReviewDetailViewController {
    func backToHome() {
        navigator?.pop(sender: self, popType: .popToRoot, animated: true)
    }
}
