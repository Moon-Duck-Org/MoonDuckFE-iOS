//
//  HomeReviewImageDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/24/24.
//

import UIKit

final class HomeReviewImageDataSource: NSObject {
    fileprivate var review: Review
    private var tappedHandler: (() -> Void)?

    init(review: Review) {
        self.review = review
    }

    func configure(with collectionView: UICollectionView, tappedHandler: (() -> Void)? = nil) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ReviewImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ReviewImageCollectionViewCell.className)
        self.tappedHandler = tappedHandler
    }
}

// MARK: - UICollectionViewDataSource
extension HomeReviewImageDataSource: UICollectionViewDataSource {
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
extension HomeReviewImageDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = review.imageUrlList.count
       
        let ratioDynamic = getImageSizeForRatioDynamic(with: collectionView)
        var width = ratioDynamic.width
        let height = ratioDynamic.height
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: width, height: height) // 기본값 반환
        }
        if count == 1 {
            let margin: CGFloat = (flowLayout.sectionInset.left + flowLayout.sectionInset.right) + (CGFloat(count - 1) * flowLayout.minimumLineSpacing)
            width = (collectionView.bounds.width - margin) / CGFloat(count)
        }
        
        return CGSize(width: width, height: height)
    }
    
    private func getImageSizeForRatioDynamic(with collectionView: UICollectionView) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.width
        let ratioDynamic: CGFloat = round(deviceWidth / 375 * 181)
        return CGSize(width: ratioDynamic, height: ratioDynamic)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedHandler?()
    }
}
