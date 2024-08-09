//
//  WriteImageDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import UIKit

final class WriteImageDataSource: NSObject {
    fileprivate let presenter: WriteReviewPresenter

    init(presenter: WriteReviewPresenter) {
        self.presenter = presenter
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: WriteImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: WriteImageCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension WriteImageDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfImages
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: WriteImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteImageCollectionViewCell.className, for: indexPath) as? WriteImageCollectionViewCell {
            let image = presenter.image(at: indexPath.row)
            let deleteImageHandler: (() -> Void)? = presenter.deleteImageHandler(at: indexPath.row)
            cell.configure(with: image, deleteImageHandler: deleteImageHandler)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension WriteImageDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 83.0, height: 83.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectImage(at: indexPath.row)
    }
}
