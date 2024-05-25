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
                return isSelected ? Asset.Color.white.color : Asset.Color.gray3.color
            }
        }
        
        func getBoderColor(isSelected: Bool) -> UIColor? {
            switch self {
            case .write:
                return isSelected ? Asset.Color.black.color : .clear
            default:
                return nil
            }
        }
        
        func getBorderWidth(isSelected: Bool) -> CGFloat? {
            switch self {
            case .write:
                return isSelected ? 1.0 : 0.0
            default:
                return nil
            }
        }
    }
    
    @IBOutlet private weak var vBack: UIView?
    @IBOutlet private weak var lbTitle: UILabel?
    @IBOutlet private weak var ivIcon: UIImageView?
    
    var cellMode: CellMode = .home
    private var isSelect: Bool = false
    
    func configure(with category: Category, isSelect: Bool = false) {
        lbTitle?.text = category.title
        ivIcon?.image = category.image
        
        setSelect(isSelect)
    }
    
    private func setSelect(_ isSelect: Bool) {
        vBack?.backgroundColor = cellMode.getBackColor(isSelected: isSelect)
        
        if let color = cellMode.getBoderColor(isSelected: isSelect),
        let width = cellMode.getBorderWidth(isSelected: isSelect) {
            vBack?.addBorder(color: color, width: width)
        }
    }
}
