//
//  WriteReviewViewController.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import UIKit

protocol WriteReviewView: BaseView {
    // UI Logic
    func updateCategory(_ category: Category)
    func updateProgramInfo(title: String, subTitle: String)
    func updateTitleCountLabel(_ text: String)
    func updateContentCountLabel(_ text: String)
    func updateRating(_ rating: Int)
    
    // Navigation
    func backToHome()
    func popToSelf()
    func moveSelectCategory(with presenter: SelectProgramPresenter)
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
    @IBOutlet private weak var titleCountLabel: UILabel!
    
    @IBOutlet private weak var contentTextView: TextView! {
        didSet {
            contentTextView.delegate = self
        }
    }
    @IBOutlet private weak var contentCountLabel: UILabel!
        
    @IBOutlet weak private var ratingButton1: UIButton!
    @IBOutlet weak private var ratingButton2: UIButton!
    @IBOutlet weak private var ratingButton3: UIButton!
    @IBOutlet weak private var ratingButton4: UIButton!
    @IBOutlet weak private var ratingButton5: UIButton!
    
    @IBOutlet private weak var linkTextField: TextField! {
        didSet {
            linkTextField.delegate = self
        }
    }
    
    // @IBAction
    @IBAction private func tapCancelButton(_ sender: Any) {
        backToHome()
    }
    
    @IBAction private func tapSaveButton(_ sender: Any) {
        presenter.tapSaveButton()
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
        registerNotifications()
        presenter.view = self
        presenter.viewDidLoad()
        
        registeRatingButtonAction()
    }
    
    deinit {
        unregisterNotifications()
    }
    
}

// MARK: - UI Logic
extension WriteReviewViewController {
    
    func updateCategory(_ category: Category) {
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
    
    func updateRating(_ rating: Int) {
        ratingButton1.isSelected = rating > 0
        ratingButton2.isSelected = rating > 1
        ratingButton3.isSelected = rating > 2
        ratingButton4.isSelected = rating > 3
        ratingButton5.isSelected = rating > 4
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
    
    private func registeRatingButtonAction() {
        ratingButton1.addTarget(self, action: #selector(tapRatingButton(_:)), for: .touchUpInside)
        ratingButton2.addTarget(self, action: #selector(tapRatingButton(_:)), for: .touchUpInside)
        ratingButton3.addTarget(self, action: #selector(tapRatingButton(_:)), for: .touchUpInside)
        ratingButton4.addTarget(self, action: #selector(tapRatingButton(_:)), for: .touchUpInside)
        ratingButton5.addTarget(self, action: #selector(tapRatingButton(_:)), for: .touchUpInside)
    }
    
    @objc
    private func tapRatingButton(_ sender: UIButton) {
        presenter.tapRatingButton(at: sender.tag)
    }
}

// MARK: - Navigation
extension WriteReviewViewController {
    func backToHome() {
        navigator?.pop(sender: self, popType: .popToRoot, animated: true)
    }
    
    func popToSelf() {
        navigator?.pop(sender: self, popType: .popToSelf, animated: true)
    }
    
    func moveSelectCategory(with presenter: SelectProgramPresenter) {
        navigator?.show(seque: .selectProgram(presenter: presenter), sender: self, transition: .navigation, animated: true)
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
