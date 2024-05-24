//
//  Alert.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

class Alert {
    
    /**
     # show
     - parameters:
        - vc : 이 메서드를 사용할 vc
        - title : Alert Title문구
        - message : Alert 메세지 문구
     - Authors: suni
     - Note:'아니오'/'네' 버튼 알럿 노출
     */
    static func show(_ viewController: UIViewController,
                     title: String? = "",
                     message: String? = "",
                     cancelTitle: String = L10n.Localizable.cancel,
                     destructiveTitle: String = L10n.Localizable.done,
                     cancelHandler: (() -> Void)? = nil,
                     destructiveHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
                alert.dismiss(animated: true)
                cancelHandler?()
            }
            let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
                destructiveHandler?()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(destructiveAction)
                
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
