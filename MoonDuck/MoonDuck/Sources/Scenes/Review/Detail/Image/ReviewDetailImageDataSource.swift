//
//  ReviewDetailImageDataSource.swift
//  MoonDuck
//
//  Created by suni on 7/8/24.
//

import UIKit

final class ReviewDetailImageDataSource: NSObject {
    private let presenter: ReviewDetailPresenter
    fileprivate let config = Config()
    
    struct Config {
        let spacing: CGFloat = 11
        let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    init(with presenter: ReviewDetailPresenter) {
        self.presenter = presenter
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ReviewImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ReviewImageCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewDetailImageDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.review.imageUrlList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReviewImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCollectionViewCell.className, for: indexPath) as? ReviewImageCollectionViewCell {
            if indexPath.row < presenter.review.imageUrlList.count {
                let imageUrl = presenter.review.imageUrlList[indexPath.row]
                cell.configure(with: imageUrl)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ReviewDetailImageDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = presenter.review.imageUrlList.count
        let height = collectionView.bounds.height - config.sectionInsets.top - config.sectionInsets.bottom
        
        var width = height
        if count == 1 {
            let margin: CGFloat = (config.sectionInsets.left + config.sectionInsets.right) + (CGFloat(count - 1) * config.spacing)
            width = (collectionView.bounds.width - margin) / CGFloat(count)
        }
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectReviewImage(indexPath.row)
    }
}
