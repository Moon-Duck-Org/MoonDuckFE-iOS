//
//  BaseCategoryCell.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

class BaseCategoryCell: UICollectionViewCell {

    enum CellMode {
        case home
        case write
        
        func getBackColor(isSelected: Bool) -> UIColor {
            switch self {
            case .home:
                return isSelected ? Asset.Color.main.color.withAlphaComponent(0.5) : Asset.Color.white.color
            case .write:
                return Asset.Color.white.color
            }
        }
    }
    
    @IBOutlet private weak var vBack: UIView?
    @IBOutlet private weak var lbTitle: UILabel?
    @IBOutlet private weak var ivIcon: UIImageView?
    
    var cellMode: CellMode = .home
    
    func configure(with category: Category) {
        lbTitle?.text = category.title
        ivIcon?.image = category.image
    }
    
    func setSelect(_ isSelect: Bool) {
        vBack?.backgroundColor = cellMode.getBackColor(isSelected: isSelect)
    }
}
