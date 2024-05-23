//
//  HomeViewDataSource.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

final class HomeViewDataSource: NSObject {
    fileprivate let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(HomeCategoryCvCell.self, forCellWithReuseIdentifier: HomeCategoryCvCell.className)
    }
}

extension HomeViewDataSource: UICollectionViewDataSource {
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

extension HomeViewDataSource: UICollectionViewDelegate {
    
}
