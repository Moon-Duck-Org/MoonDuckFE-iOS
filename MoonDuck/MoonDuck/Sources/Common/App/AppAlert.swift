//
//  AppAlert.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

class AppAlert {
    static var `default` = AppAlert()
    
    func showDestructive(_ viewController: UIViewController,
                         title: String? = "",
                         message: String? = "",
                         cancelTitle: String = L10n.Localizable.cancel,
                         destructiveTitle: String = "삭제",
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
            
            viewController.present(alert, animated: true)
        }
        
    }
//
//    func showAlert(_ viewController: UIViewController,
//                   style: AlertStyle = .defualtTwoButton,
//                   title: String? = "",
//                   message: String? = "",
//                   cancelTitle: String = L10n.Localizable.cancel,
//                   completeTitle: String = L10n.Localizable.done,
//                   destructiveTitle: String = "삭제",
//                   cancelHandler: (() -> Void)? = nil,
//                   completeHandler: (() -> Void)? = nil,
//                   destructiveHandler: (() -> Void)? = nil) {
//        DispatchQueue.main.async {
//            self.dismissAlert()
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            
//            if style == .deleteTwoButton {
//                let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
//                    alert.dismiss(animated: true)
//                    cancelHandler?()
//                }
//                let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
//                    destructiveHandler?()
//                }
//                alert.addAction(cancelAction)
//                alert.addAction(destructiveAction)
//            } else {
//                let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
//                    alert.dismiss(animated: true)
//                    cancelHandler?()
//                }
//                let completeAction = UIAlertAction(title: completeTitle, style: .default) { _ in
//                    alert.dismiss(animated: true)
//                    cancelHandler?()
//                }
//                alert.addAction(cancelAction)
//                alert.addAction(completeAction)
//            }
//            viewController.present(alert, animated: true, completion: {
//                self.currentAlert = alert
//            })
//        }
//    }
//    
//    func showActionSheet(_ viewController: UIViewController,
//                         style: ActionSheetStyle = .deleteTwoButton,
//                         title: String? = nil,
//                         message: String? = nil,
//                         defaultTitle: String = L10n.Localizable.cancel,
//                         destructiveTitle: String = L10n.Localizable.done,
//                         defaultHandler: (() -> Void)? = nil,
//                         destructiveHandler: (() -> Void)? = nil,
//                         cancelTitle: String = L10n.Localizable.close,
//                         cancelHandler: (() -> Void)? = nil) {
//        DispatchQueue.main.async {
//            self.dismissAlert()
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//            
//            if style == .deleteTwoButton {
//                let defaultAction = UIAlertAction(title: defaultTitle, style: .default) { _ in
//                    alert.dismiss(animated: true)
//                    defaultHandler?()
//                }
//                let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
//                    destructiveHandler?()
//                }
//                alert.addAction(defaultAction)
//                alert.addAction(destructiveAction)
//                
//                let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
//                    alert.dismiss(animated: true)
//                    cancelHandler?()
//                }
//                alert.addAction(cancelAction)
//            }
//            
//            viewController.present(alert, animated: true, completion: {
//                self.currentAlert = alert
//            })
//        }
//    }
    
    func showList(_ viewController: UIViewController,
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
            
            viewController.present(alert, animated: true)
        }
    }
    
    func showSystemShare(_ viewController: UIViewController, str: String? = nil) {
        guard let str else { return }
        DispatchQueue.main.async {
            let shareContent = [str]
            let activityController = UIActivityViewController(activityItems: shareContent,
                                                              applicationActivities: nil)
            viewController.present(activityController, animated: true)
        }
    }
    
    func showReviewOption(_ viewController: UIViewController,
                          writeHandler: (() -> Void)? = nil,
                          shareHandler: (() -> Void)? = nil,
                          deleteHandler: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let writeAction = UIAlertAction(title: "수정", style: .default) { _ in
                alert.dismiss(animated: true)
                writeHandler?()
            }
            alert.addAction(writeAction)
            
            let shareAction = UIAlertAction(title: "공유", style: .default) { _ in
                alert.dismiss(animated: true)
                shareHandler?()
            }
            alert.addAction(shareAction)
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                alert.dismiss(animated: true)
                deleteHandler?()
            }
            alert.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "닫기", style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(cancelAction)
            
            viewController.present(alert, animated: true)
        }
    }
}
