//
//  TextField.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

class TextField: UITextField {
    
    override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                self.addPlaceHolder(placeholder)
            }
        }
    }
    
    @IBInspectable var normalBorderColor: UIColor = .clear {
        didSet {
            normal()
        }
    }
    @IBInspectable var errorBorderColor: UIColor = Asset.Color.red.color
    
    func normal() {
        self.addBorder(color: normalBorderColor, width: 1)
    }
    
    func error() {
        self.addBorder(color: errorBorderColor, width: 1)
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initview()
    }
    
    private func initview() {
        self.textColor = Asset.Color.black.color
        self.layer.cornerRadius = 8
        self.addRightAndLeftPadding(width: 15)
        self.font = FontFamily.NotoSansCJKKR.regular.font(size: 14)
        self.normal()
        
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}
