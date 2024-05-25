//
//  ReviewEditCategoryCvDataSource.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

final class ReviewEditCategoryCvDataSource: NSObject {
    fileprivate let presenter: BoardEditPresenter
    
    init(presenter: BoardEditPresenter) {
        self.presenter = presenter
    }
    
    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ReviewEditCategoryCvCell.className, bundle: nil), forCellWithReuseIdentifier: ReviewEditCategoryCvCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewEditCategoryCvDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReviewEditCategoryCvCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewEditCategoryCvCell.className, for: indexPath) as? ReviewEditCategoryCvCell {
            let category = presenter.category(at: indexPath.row)
            cell.cellMode = .write
            
            var isSelect = false
            if let indexOfSelectedCategory = presenter.indexOfSelectedCategory,
               indexOfSelectedCategory == indexPath.row {
                isSelect = true
            }
            cell.configure(with: category, isSelect: isSelect)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ReviewEditCategoryCvDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58.0, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard presenter.indexOfSelectedCategory != indexPath.row else { return }
    
        presenter.selectCategory(at: indexPath.row)
    }
}
