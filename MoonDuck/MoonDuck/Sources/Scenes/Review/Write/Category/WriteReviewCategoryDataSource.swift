//
//  WriteReviewCategoryDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import UIKit

final class WriteReviewCategoryDataSource: NSObject {
    fileprivate let presenter: WriteReviewCategoryPresenter

    init(presenter: WriteReviewCategoryPresenter) {
        self.presenter = presenter
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: WriteReviewCategoryCvCell.className, bundle: nil), forCellWithReuseIdentifier: WriteReviewCategoryCvCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension WriteReviewCategoryDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCategories
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: WriteReviewCategoryCvCell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteReviewCategoryCvCell.className, for: indexPath) as? WriteReviewCategoryCvCell {
            cell.cellMode = .write

            if let category = presenter.category(at: indexPath.row) {
                let isSelect = presenter.indexOfSelectedCategory == indexPath.row
                cell.configure(with: category, isSelect: isSelect)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension WriteReviewCategoryDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58.0, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard presenter.indexOfSelectedCategory != indexPath.row else { return }

        presenter.selectCategory(at: indexPath.row)
    }
}
