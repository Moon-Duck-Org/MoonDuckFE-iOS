////
////  HomeBoardImageCvDataSrouce.swift
////  MoonDuck
////
////  Created by suni on 5/26/24.
////
//
//import UIKit
//
//final class HomeBoardImageCvDataSrouce: NSObject {
//    
//    func configure(with collectionView: UICollectionView) {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UINib(nibName: BoardImageCvCell.className, bundle: nil), forCellWithReuseIdentifier: BoardImageCvCell.className)
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension HomeBoardImageCvDataSrouce: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return presenter.numberOfCategory
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell: HomeCategoryCvCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCvCell.className, for: indexPath) as? HomeCategoryCvCell {
//            let category = presenter.category(at: indexPath.row)
//            let isSelect = presenter.indexOfSelectedCategory == indexPath.row
//            cell.configure(with: category, isSelect: isSelect)
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//}
//
//// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
//extension HomeBoardImageCvDataSrouce: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return HomeCategoryCvCell.cellSize(collectionView, cellCount: presenter.numberOfCategory)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard presenter.indexOfSelectedCategory != indexPath.row else { return }
//    
//        presenter.selectCategory(at: indexPath.row)
//    }
//}
