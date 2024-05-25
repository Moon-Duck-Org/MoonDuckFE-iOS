//
//  HomeCategoryCvDataSource.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

final class HomeCategoryCvDataSource: NSObject {
    fileprivate let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: HomeCategoryCvCell.className, bundle: nil), forCellWithReuseIdentifier: HomeCategoryCvCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeCategoryCvDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: HomeCategoryCvCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCvCell.className, for: indexPath) as? HomeCategoryCvCell {
            let category = presenter.category(at: indexPath.row)
            let isSelect = presenter.indexOfSelectedCategory == indexPath.row
            cell.configure(with: category, isSelect: isSelect)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeCategoryCvDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeCategoryCvCell.cellSize(collectionView, cellCount: presenter.numberOfCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard presenter.indexOfSelectedCategory != indexPath.row else { return }
    
        presenter.selectCategory(at: indexPath.row)
    }
}
