//
//  HomeCategoryCvCell.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

class HomeCategoryCvCell: BaseCategoryCell {
    
    public static func cellSize(_ collectionView: UICollectionView, cellCount: Int) -> CGSize {
        let floatCount: CGFloat = CGFloat(cellCount)
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= 56 // Insets
        cellSize.width -= CGFloat(7 * (floatCount - 1))
        cellSize.width = cellSize.width / floatCount
        
        cellSize.height -= 12 // Insets
        
        return cellSize
//        return CGSize(width: 10, height: 10)
    }
}
