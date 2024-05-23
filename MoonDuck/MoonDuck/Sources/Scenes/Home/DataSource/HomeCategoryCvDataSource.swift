//
//  HomeCategoryCvDataSource.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
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

extension HomeCategoryCvDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCategoryCvCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCvCell.className, for: indexPath) as! HomeCategoryCvCell
        let category = presenter.category(at: indexPath.row)
        cell.configure(with: category)
        return cell
    }
}

extension HomeCategoryCvDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeCategoryCvCell.cellSize(collectionView, cellCount: presenter.numberOfCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: [홈화면] 카테고리 클릭 이벤트
    }
}
