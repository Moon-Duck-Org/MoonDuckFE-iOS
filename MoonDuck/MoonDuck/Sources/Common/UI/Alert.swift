//
//  Alert.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

class Alert {
    
    enum AlertStyle {
        case defualtTwoButton
        case deleteTwoButton
    }
    
    enum ActionSheetStyle {
        case deleteTwoButton
    }
    
    static func showAlert(_ viewController: UIViewController,
                          style: AlertStyle = .defualtTwoButton,
                          title: String? = "",
                          message: String? = "",
                          cancelTitle: String = L10n.Localizable.cancel,
                          completeTitle: String = L10n.Localizable.done,
                          destructiveTitle: String = L10n.Localizable.done,
                          cancelHandler: (() -> Void)? = nil,
                          completeHandler: (() -> Void)? = nil,
                          destructiveHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            if style == .deleteTwoButton {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
                    alert.dismiss(animated: true)
                    cancelHandler?()
                }
                let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
                    destructiveHandler?()
                }
                alert.addAction(cancelAction)
                alert.addAction(destructiveAction)
            } else {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
                    alert.dismiss(animated: true)
                    cancelHandler?()
                }
                let completeAction = UIAlertAction(title: completeTitle, style: .default) { _ in
                    alert.dismiss(animated: true)
                    cancelHandler?()
                }
                alert.addAction(cancelAction)
                alert.addAction(completeAction)
            }
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showActionSheet(_ viewController: UIViewController,
                                style: ActionSheetStyle = .deleteTwoButton,
                                title: String? = nil,
                                message: String? = nil,
                                cancelTitle: String = L10n.Localizable.cancel,
                                completeTitle: String = L10n.Localizable.done,
                                destructiveTitle: String = L10n.Localizable.done,
                                cancelHandler: (() -> Void)? = nil,
                                completeHandler: (() -> Void)? = nil,
                                destructiveHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            if style == .deleteTwoButton {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
                    alert.dismiss(animated: true)
                    cancelHandler?()
                }
                let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
                    destructiveHandler?()
                }
                alert.addAction(cancelAction)
                alert.addAction(destructiveAction)
            }
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    static func showList(_ viewController: UIViewController,
                         title: String? = nil,
                         message: String? = nil,
                         buttonTitleList: [String],
                         buttonHandlerIndex: ((Int) -> Void)?,
                         cancelTitle: String = L10n.Localizable.close,
                         cancelHandler: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for (index, title) in buttonTitleList.enumerated() {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    alert.dismiss(animated: true)
                    buttonHandlerIndex?(index)
                }
                alert.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                alert.dismiss(animated: true)
                cancelHandler?()
            }
            alert.addAction(cancelAction)
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
