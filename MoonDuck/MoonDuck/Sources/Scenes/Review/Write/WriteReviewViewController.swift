//
//  WriteReviewViewController.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import UIKit

protocol WriteReviewView: BaseView {
    // UI Logic
    func updateCategory(_ category: ReviewCategory)
    func updateProgramInfo(title: String, subTitle: String)
    func updateTitleCountLabel(_ text: String)
    func updateContentCountLabel(_ text: String)
    func updateSaveButton(_ isEnabled: Bool)
    
    // Navigation
    func moveHome(with presenter: V2HomePresenter)
}

class WriteReviewViewController: BaseViewController, WriteReviewView, Navigatable {
    
    var navigator: Navigator?
    let presenter: WriteReviewPresenter
    
    // @IBOutlet
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var programTitleLabel: UILabel!
    @IBOutlet private weak var programSubTitleLabel: UILabel!
    
    @IBOutlet private weak var titleTextField: TextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    @IBOutlet private weak var contentTextView: TextView! {
        didSet {
            contentTextView.delegate = self
        }
    }
    @IBOutlet private weak var linkTextField: TextField! {
        didSet {
            linkTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var titleCountLabel: UILabel!
    @IBOutlet private weak var contentCountLabel: UILabel!
    
    @IBOutlet private weak var saveButton: UIButton!
    
    // @IBAction
    @IBAction private func cancelButtonTap(_ sender: Any) {
        back()
    }
    
    @IBAction private func titleTextFieldEditingChanged(_ sender: Any) {
        presenter.titleTextFieldEditingChanged(titleTextField.text)
    }
    
    @IBAction private func linkTextFieldEditingChanged(_ sender: Any) {
        presenter.linkTextFieldEditingChanged(linkTextField.text)
    }
    
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
    
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    deinit {
        unregisterNotifications()
    }
    
}

// MARK: - UI Logic
extension WriteReviewViewController {
    
    func updateCategory(_ category: ReviewCategory) {
        categoryImageView.image = category.roundImage
    }
    
    func updateProgramInfo(title: String, subTitle: String) {
        programTitleLabel.text = title
        programSubTitleLabel.text = subTitle
    }
    
    func updateTitleCountLabel(_ text: String) {
        titleCountLabel.text = text
    }
    
    func updateContentCountLabel(_ text: String) {
        contentCountLabel.text = text
    }
    
    func updateSaveButton(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }
    
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
    private func back() {
        navigator?.pop(sender: self)
    }
    
    func moveHome(with presenter: V2HomePresenter) {
        navigator?.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
    
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isTitle = textField == titleTextField
        return presenter.textField(textField.text, shouldChangeCharactersIn: range, replacementString: string, isTitle: isTitle)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let isTitle = textField == titleTextField
        presenter.textFieldDidBeginEditing(textField.text, isTitle: isTitle)
    }
}

// MARK: - UITextViewDelegate
extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.textViewDidChange(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return presenter.textView(textView.text, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        presenter.textViewDidBeginEditing(textView.text)
    }
}
