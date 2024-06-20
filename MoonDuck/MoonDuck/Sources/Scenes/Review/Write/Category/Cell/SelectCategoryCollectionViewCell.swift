//
//  SelectCategoryCollectionViewCell.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

class SelectCategoryCollectionViewCell: BaseCategoryCell {
    
    override func configure(with category: Category, isSelect: Bool = false) {
        super.configure(with: category, isSelect: isSelect)
        
        if isSelect {
            backView?.addBorder(color: Asset.Color.black.color, width: 1.0)
            titlaLabel?.textColor = Asset.Color.black.color
            titlaLabel?.font = FontFamily.NotoSansCJKKR.bold.font(size: 14)
            iconImageView?.image = category.image
        } else {
            backView?.addBorder(color: .clear, width: 0.0)
            titlaLabel?.textColor = Asset.Color.gray2.color
            titlaLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 14)
            iconImageView?.image = category.grayImage
        }
    }
}
