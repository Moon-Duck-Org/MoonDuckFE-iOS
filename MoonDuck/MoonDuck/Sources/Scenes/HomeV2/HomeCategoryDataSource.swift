//
//  HomeCategoryDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import UIKit

final class HomeCategoryDataSource: NSObject {
    fileprivate let presenter: V2HomePresenter
    fileprivate let config = Config()
    
    struct Config {
        let spacing: CGFloat = 7
        let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 9, right: 16)
    }

    init(presenter: V2HomePresenter) {
        self.presenter = presenter
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: HomeCategoryCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeCategoryDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCategories
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: HomeCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.className, for: indexPath) as? HomeCategoryCollectionViewCell {
            cell.cellMode = .home

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
extension HomeCategoryDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = presenter.numberOfCategories
        let margin: CGFloat = (config.sectionInsets.left + config.sectionInsets.right) + (CGFloat(count - 1) * config.spacing)
        let width = (collectionView.bounds.width - margin) / CGFloat(count)
        let height = collectionView.bounds.height - config.sectionInsets.top - config.sectionInsets.bottom
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard presenter.indexOfSelectedCategory != indexPath.row else { return }

        presenter.selectCategory(at: indexPath.row)
    }
}
