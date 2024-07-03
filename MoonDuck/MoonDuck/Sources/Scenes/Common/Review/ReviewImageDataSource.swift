//
//  ReviewImageDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/24/24.
//

import UIKit

final class ReviewImageDataSource: NSObject {
    fileprivate var review: Review
    fileprivate let config = Config()
    
    struct Config {
        let spacing: CGFloat = 11
        let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    init(review: Review) {
        self.review = review
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ReviewImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ReviewImageCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewImageDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review.imageUrlList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReviewImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCollectionViewCell.className, for: indexPath) as? ReviewImageCollectionViewCell {
            if indexPath.row < review.imageUrlList.count {
                let imageUrl = review.imageUrlList[indexPath.row]
                cell.configure(with: imageUrl)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ReviewImageDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = review.imageUrlList.count
        let height = collectionView.bounds.height - config.sectionInsets.top - config.sectionInsets.bottom
        
        var width = height
        if count == 1 {
            let margin: CGFloat = (config.sectionInsets.left + config.sectionInsets.right) + (CGFloat(count - 1) * config.spacing)
            width = (collectionView.bounds.width - margin) / CGFloat(count)
        }
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // TODO: - Review Image Selection
    }
}
