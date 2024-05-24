//
//  UITextField+Extension.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

extension UITextField {
    /**
     # addLeftPadding
     - parameters:
        - width : 패딩 간격
     - Authors: suni
     - Note: 왼쪽 간격 추가 공통 함수.
     */
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    /**
     # addRightAndLeftPadding
     - parameters:
        - width : 패딩 간격
     - Authors: suni
     - Note: 양쪽 간격 추가 공통 함수.
     */
    func addRightAndLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
    /**
     # addPlaceHolder
     - parameters:
        - text : 플레이스홀더 택스트
     - Authors: suni
     - Note: 플레이스 홀더 추가 공통 함수.
     */
    func addPlaceHolder(_ text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: Asset.Color.black.color])
    }
}
