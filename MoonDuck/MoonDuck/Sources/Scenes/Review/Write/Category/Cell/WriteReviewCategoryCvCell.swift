//
//  WriteReviewCategoryCvCell.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

class WriteReviewCategoryCvCell: BaseCategoryCell {
    
    override func configure(with category: ReviewCategory, isSelect: Bool = false) {
        super.configure(with: category, isSelect: isSelect)
        
        setSelect(isSelect: isSelect)
    }
    
    private func setSelect(isSelect: Bool) {
        let borderColor = isSelect ? Asset.Color.black.color : .clear
        let borderWidth = isSelect ? 1.0 : 0.0
        vBack?.addBorder(color: borderColor, width: borderWidth)
        
        let titleColor = isSelect ? Asset.Color.black.color : Asset.Color.gray2.color
        let titleFont = isSelect ? FontFamily.NotoSansCJKKR.bold.font(size: 14) : FontFamily.NotoSansCJKKR.medium.font(size: 14)
        lbTitle?.textColor = titleColor
        lbTitle?.font = titleFont
    }
}
