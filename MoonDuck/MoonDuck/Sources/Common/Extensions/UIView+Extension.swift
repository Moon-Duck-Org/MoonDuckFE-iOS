//
//  UIView+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

extension UIView {
 
    func roundCornersAndAddBorder(
        corners: UIRectCorner = [.topLeft, .topRight, .bottomRight, .bottomLeft],
        radius: CGFloat,
        borderWidth: CGFloat = 0.0,
        borderColor: UIColor = .clear,
        pathBounds: CGRect? = nil) {
            
        // 경로를 그립니다.
        let maskPath = UIBezierPath(
            roundedRect: (pathBounds == nil) ? bounds : pathBounds!,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        // 테두리를 그릴 레이어를 생성합니다.
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        
        // 경로를 레이어에 추가합니다.
        layer.addSublayer(borderLayer)
        
        // 모서리를 둥글게 합니다.
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func addBorder(color: UIColor = Asset.Color.black.color,
                   width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}
