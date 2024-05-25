//
//  StarRatingButton.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

//import UIKit
//
//public class StarRatingButton: UIButton {
//    
//    @IBInspectable var fillImage: UIImage = Asset.Assets.starFillLarge.image
//    @IBInspectable var emptyImage: UIImage = Asset.Assets.starLarge.image
//    
//    func select() {
//        self.isSelected = true
//    }
//    
//    func unSelect() {
//        self.isSelected = false
//    }
//    
//    // MARK: init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initview()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        initview()
//    }
//    
//    private func initview() {
//        self.setImage(fillImage, for: .selected)
//        self.setImage(emptyImage, for: .normal)
//    }
//}
