//
//  WriteReviewViewController.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import UIKit

protocol WriteReviewView: BaseView {
    
}

class WriteReviewViewController: BaseViewController, WriteReviewView, Navigatable {
    
    var navigator: Navigator!
    let presenter: WriteReviewPresenter
    
    // @IBOutlet
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    // @IBAction
    
    init(navigator: Navigator,
         presenter: WriteReviewPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: WriteReviewViewController.className, bundle: Bundle(for: WriteReviewViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    deinit {
        unregisterNotifications()
    }
    
}

// MARK: - UI Logic
extension WriteReviewViewController {
    
    // 노티피케이션 등록
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션 등록 해제
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardInfo = UIKeyboardInfo(notification: notification) else {
            return
        }
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = keyboardInfo.frame.size.height
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let keyboardInfo = UIKeyboardInfo(notification: notification) else {
            return
        }
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = 10
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}

// MARK: - Navigation
extension WriteReviewViewController {
    
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return presenter.textFieldShouldReturn(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.textFieldDidEndEditing(textField.text)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        presenter.textFieldShouldBeginEditing(textField.text)
    }
}
