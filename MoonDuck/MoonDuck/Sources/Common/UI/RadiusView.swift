//
//  RadiusView.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

public class RadiusView: UIView {

    /// 노멀 백그라운드 컬러 : 기본값 클리어
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// 테두리 넓이 : 기본 0
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
        
    /// corner radius값 : 기본 2
    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
