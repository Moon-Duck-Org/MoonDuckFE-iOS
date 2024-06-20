//
//  SelectCategoryDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import UIKit

final class SelectCategoryDataSource: NSObject {
    fileprivate let presenter: SelectCategoryPresenter

    init(presenter: SelectCategoryPresenter) {
        self.presenter = presenter
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: SelectCategoryCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: SelectCategoryCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension SelectCategoryDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCategories
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: SelectCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCategoryCollectionViewCell.className, for: indexPath) as? SelectCategoryCollectionViewCell {
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
extension SelectCategoryDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58.0, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard presenter.indexOfSelectedCategory != indexPath.row else { return }

        presenter.selectCategory(at: indexPath.row)
    }
}
