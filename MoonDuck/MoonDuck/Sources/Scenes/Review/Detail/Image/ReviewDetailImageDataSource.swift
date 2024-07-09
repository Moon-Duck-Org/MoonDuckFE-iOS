//
//  ReviewDetailImageDataSource.swift
//  MoonDuck
//
//  Created by suni on 7/8/24.
//

import UIKit

final class ReviewDetailImageDataSource: NSObject {
    private let presenter: ReviewDetailPresenter

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
        presenter.selectReviewImage(indexPath.row)
    }
}
