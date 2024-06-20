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
    }
    
    @IBOutlet weak var backView: UIView?
    @IBOutlet weak var titlaLabel: UILabel?
    @IBOutlet weak var iconImageView: UIImageView?
    
    var cellMode: CellMode = .home
    private var isSelect: Bool = false
    
    func configure(with category: Category, isSelect: Bool = false) {
        titlaLabel?.text = category.title
        iconImageView?.image = category.image
        
        setSelect(isSelect)
    }
    
    private func setSelect(_ isSelect: Bool) {
        backView?.backgroundColor = cellMode.getBackColor(isSelected: isSelect)
    }
}
