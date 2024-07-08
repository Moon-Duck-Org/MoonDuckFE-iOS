//
//  ReviewDetailImageViewController.swift
//  MoonDuck
//
//  Created by suni on 7/8/24.
//

import UIKit

protocol ReviewDetailImageView: BaseView {
    // UI Logic
    func updateImageCountLabelText(_ count: String)
    func scrollToPage(_ page: Int)
    
    // Navigation
}

class ReviewDetailImageViewController: BaseViewController, ReviewDetailImageView {
    
    private let presenter: ReviewDetailImagePresenter
    
    // @IBOutlet
    @IBOutlet private weak var imageCountLabel: UILabel!
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        back()
    }
    
    init(navigator: Navigator,
         presenter: ReviewDetailImagePresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: ReviewDetailImageViewController.className, bundle: Bundle(for: ReviewDetailImageViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: ReviewDetailImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ReviewDetailImageCollectionViewCell.className)
        
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension ReviewDetailImageViewController {
    func updateImageCountLabelText(_ count: String) {
        imageCountLabel.text = count
    }
    
    func scrollToPage(_ page: Int) {
        if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = imageCollectionView.frame.width
            let offset = CGPoint(x: width * CGFloat(page), y: 0)
            DispatchQueue.main.async {
                self.imageCollectionView.setContentOffset(offset, animated: false)
            }
        }
     }
}
// MARK: - Navigation
extension ReviewDetailImageViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
}
// MARK: - UICollectionViewDataSource
extension ReviewDetailImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfImages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReviewDetailImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewDetailImageCollectionViewCell.className, for: indexPath) as? ReviewDetailImageCollectionViewCell {
            if let imageUrl = presenter.imageUrl(at: indexPath.row) {
                cell.configure(with: imageUrl)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ReviewDetailImageViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = imageCollectionView.frame.width
        let height = imageCollectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = imageCollectionView.frame.width
            let currentPage = Int(imageCollectionView.contentOffset.x / width)
            presenter.scrollViewDidEndDecelerating(currentPage)
        }
    }
}
