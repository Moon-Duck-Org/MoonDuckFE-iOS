//
//  NoticePopupView.swift
//  MoonDuck
//
//  Created by suni on 2/4/25.
//

import UIKit

class NoticePopupView: UIView {
    
    var closeButtonHandler: (() -> Void)?
    
    @IBAction private func didTapCloseButton(_ sender: UIButton) {
        self.closeButtonHandler?()
        self.closeButtonHandler = nil
        
        self.removeFromSuperview()
    }
}
