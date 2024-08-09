//
//  TextView.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

class TextView: UITextView {
        
    // MARK: init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initview()
    }
    
    private func initview() {
        self.textColor = Asset.Color.black.color
        self.layer.cornerRadius = 8
        self.font = FontFamily.NotoSansCJKKR.regular.font(size: 14)
        self.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}
