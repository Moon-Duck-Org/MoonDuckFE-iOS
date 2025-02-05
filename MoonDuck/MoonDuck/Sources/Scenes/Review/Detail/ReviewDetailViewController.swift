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
    func showSystemShare(with url: URL)
    
    // Navigation
    func backToHome()
    func moveWriteReview(with presenter: WriteReviewPresenter)
    func moveDetailImage(with presenter: ReviewDetailImagePresenter)
    func popToSelf()
}

class ReviewDetailViewController: BaseViewController, ReviewDetailView {
    
    private let presenter: ReviewDetailPresenter
    private var imageDataSource: ReviewDetailImageDataSource?
    private var linkButtonHandler: (() -> Void)?
    
    // @IBOutlet
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var programTitleLabel: UILabel!
    @IBOutlet private weak var programSubTitleLabel: UILabel!
    
    @IBOutlet private weak var ratingButton1: UIButton!
    @IBOutlet private weak var ratingButton2: UIButton!
    @IBOutlet private weak var ratingButton3: UIButton!
    @IBOutlet private weak var ratingButton4: UIButton!
    @IBOutlet private weak var ratingButton5: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var linkViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var linkLabel: UILabel!
    
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        backToHome()
    }
    @IBAction private func optionButtonTapped(_ sender: Any) {
        showOptionAlert()
    }
    @IBAction private func linkTapped(_ sender: Any) {
        linkButtonHandler?()
    }
    
    init(navigator: Navigator,
         presenter: ReviewDetailPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: ReviewDetailViewController.className, bundle: Bundle(for: ReviewDetailViewController.self))
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
            linkButtonHandler = { Utils.openSafariViewController(urlString: link)
            }
        } else {
            linkLabel.text = ""
            linkView.isHidden = true
            linkViewHeightConstraint.constant = 0
            linkButtonHandler = nil
        }
        
        imageDataSource = ReviewDetailImageDataSource(with: presenter)
        imageDataSource?.configure(with: imageCollectionView)
        imageCollectionView.reloadData()
        
        if review.imageUrlList.count > 0 {
            imageCollectionView.isHidden = false
            imageViewHeightConstraint.constant = getImageSizeForRatioDynamic(with: imageCollectionView).height
            
            if let flowLayout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let sectionInsets = flowLayout.sectionInset
                imageViewHeightConstraint.constant += sectionInsets.top + sectionInsets.bottom
            }
        } else {
            imageCollectionView.isHidden = true
            imageViewHeightConstraint.constant = 0
        }
    }
    
    func showSystemShare(with url: URL) {
        Utils.showSystemShare(self, url: url)
    }
    
    private func getImageSizeForRatioDynamic(with collectionView: UICollectionView) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.width
        let ratioDynamic: CGFloat = round(deviceWidth / 375 * 181)
        return CGSize(width: ratioDynamic, height: ratioDynamic)
    }
    
    private func updateRating(for rating: Int) {
        ratingButton1.isSelected = rating > 0
        ratingButton2.isSelected = rating > 1
        ratingButton3.isSelected = rating > 2
        ratingButton4.isSelected = rating > 3
        ratingButton5.isSelected = rating > 4
    }
    
    private func showOptionAlert() {
        AppAlert.default
            .showReviewOption(
                self,
                writeHandler: presenter.writeReviewHandler(),
                shareHandler: presenter.shareReviewHandler(),
                deleteHandler: { [weak self] in
                    self?.showDeleteReviewAlert()
                }
            )
    }
    
    private func showDeleteReviewAlert() {
        AppAlert.default
            .showDestructive(
                self,
                title: L10n.Localizable.Review.deleteMessage,
                destructiveHandler: presenter.deleteReviewHandler()
            )
    }
}

// MARK: - Navigation
extension ReviewDetailViewController {
    func backToHome() {
        navigator?.pop(sender: self, popType: .popToRoot, animated: true)
    }
    
    func moveWriteReview(with presenter: WriteReviewPresenter) {
        navigator?.show(seque: .writeReview(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveDetailImage(with presenter: ReviewDetailImagePresenter) {
        navigator?.show(seque: .reviewDetailImage(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func popToSelf() {
        navigator?.pop(sender: self, popType: .popToSelf, animated: true)
    }
}
