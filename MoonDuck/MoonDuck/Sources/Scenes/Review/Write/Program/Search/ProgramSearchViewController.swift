//
//  ProgramSearchViewController.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

protocol ProgramSearchView: BaseView {
    // UI Logic
    func reloadTableView()
    func updateTextFieldPlaceHolder(with placeHolder: String)
    func updateEmptyResultViewHidden(_ isHidden: Bool)
    func updateUserInputButtonEnabled(_ isEnabled: Bool)
    
    // Navigation
    func moveWriteReview(with presenter: WriteReviewViewPresenter)
}

class ProgramSearchViewController: BaseViewController, ProgramSearchView, Navigatable {
    
    var navigator: Navigator?
    private let presenter: ProgramSearchPresenter
    private let searchDataSource: ProgramSearchDataSource
    
    // @IBOutlet
    @IBOutlet private weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchTextField: TextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    @IBOutlet private weak var resultTableView: UITableView!
    @IBOutlet private weak var emptyResultView: UIView!
    @IBOutlet private weak var userInputButton: RadiusButton! {
        didSet {
            userInputButton.setTitleColor(.gray2, for: .disabled)
        }
    }
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    
    @IBAction private func searchTextFieldEditingChanged(_ sender: Any) {
        presenter.searchTextFieldEditingChanged(searchTextField.text)
    }
    
    @IBAction private func userInputButtonTapped(_ sender: Any) {
        throttler.throttle {
            self.presenter.userInputButtonTapped()
        }
    }
    
    init(navigator: Navigator,
         presenter: ProgramSearchPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.searchDataSource = ProgramSearchDataSource(presenter: self.presenter)
        super.init(nibName: ProgramSearchViewController.className, bundle: Bundle(for: ProgramSearchViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        presenter.view = self
        presenter.viewDidLoad()
        
        searchDataSource.configure(with: resultTableView)
    }
    
    deinit {
        unregisterNotifications()
    }
}

// MARK: - UI Logic
extension ProgramSearchViewController {
    func updateTextFieldPlaceHolder(with placeHolder: String) {
        searchTextField.placeholder = placeHolder
    }
    
    func reloadTableView() {
        resultTableView.reloadData()
    }
    
    func updateEmptyResultViewHidden(_ isHidden: Bool) {
        emptyResultView.isHidden = isHidden
    }
    
    func updateUserInputButtonEnabled(_ isEnabled: Bool) {
        userInputButton.isEnabled = isEnabled
        userInputButton.borderColor = isEnabled ? .black : .gray2
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
        let bottomSafeAreaInset = view.safeAreaInsets.bottom
        buttonBottomConstraint.constant = keyboardInfo.frame.size.height - bottomSafeAreaInset + 13.0
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
        buttonBottomConstraint.constant = 5
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}

// MARK: - Navigation
extension ProgramSearchViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
    
    func moveWriteReview(with presenter: WriteReviewViewPresenter) {
        navigator?.show(seque: .writeReview(presenter: presenter), sender: self, transition: .navigation, animated: false)
    }
}

// MARK: - UITextFieldDelegate
extension ProgramSearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.textFieldDidBeginEditing(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return presenter.textFieldShouldReturn(textField.text)
    }
}
