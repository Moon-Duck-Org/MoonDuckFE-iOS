//
//  AppAlert.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

class AppAlert {
    static let `default` = AppAlert()
        
    func showDestructive(_ viewController: UIViewController,
                         title: String? = "",
                         message: String? = "",
                         cancelTitle: String = L10n.Localizable.Button.cancel,
                         destructiveTitle: String = L10n.Localizable.Button.delete,
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
    
    func showCancelAndDone(_ viewController: UIViewController,
                           title: String? = "",
                           message: String? = "",
                           cancelTitle: String = L10n.Localizable.Button.cancel,
                           doneTitle: String = L10n.Localizable.Button.done,
                           cancelHandler: (() -> Void)? = nil,
                           doneHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                alert.dismiss(animated: true)
                cancelHandler?()
            }
            let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
                doneHandler?()
            }
            alert.addAction(cancelAction)
            alert.addAction(doneAction)
            
            viewController.present(alert, animated: true)
        }
    }
    
    func showDone(_ viewController: UIViewController,
                  title: String? = "",
                  message: String? = "",
                  doneTitle: String? = L10n.Localizable.Button.done,
                  doneHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: doneTitle, style: .default) { _ in
                alert.dismiss(animated: true)
                doneHandler?()
            }
            alert.addAction(doneAction)
            
            viewController.present(alert, animated: true)
        }
    }
    
    func showAuthError(_ viewController: UIViewController,
                       doneHandler: (() -> Void)? = nil) {
        showDone(viewController, title: L10n.Localizable.Error.authMessage)
    }
    
    func showNetworkError(_ viewController: UIViewController) {
        showDone(viewController, message: L10n.Localizable.Error.networkMessage)
    }
    
    func showSystemErrorAlert(_ viewController: UIViewController) {
        showDone(viewController, message: L10n.Localizable.Error.systemMessage)
    }
    
    func showList(_ viewController: UIViewController,
                  title: String? = nil,
                  message: String? = nil,
                  buttonTitleList: [String],
                  buttonHandlerIndex: ((Int) -> Void)?,
                  cancelTitle: String = L10n.Localizable.Button.close,
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
    
    func showReviewOption(_ viewController: UIViewController,
                          writeHandler: (() -> Void)? = nil,
                          deleteHandler: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let writeAction = UIAlertAction(title: L10n.Localizable.Button.edit, style: .default) { _ in
                alert.dismiss(animated: true)
                writeHandler?()
            }
            alert.addAction(writeAction)
            
            let deleteAction = UIAlertAction(title: L10n.Localizable.Button.delete, style: .destructive) { _ in
                alert.dismiss(animated: true)
                deleteHandler?()
            }
            alert.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: L10n.Localizable.Button.close, style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(cancelAction)
            
            viewController.present(alert, animated: true)
        }
    }
}
