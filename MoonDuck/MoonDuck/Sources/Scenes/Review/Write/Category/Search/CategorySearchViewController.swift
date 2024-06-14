//
//  CategorySearchViewController.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

protocol CategorySearchView: BaseView {
     func reloadTableView()
}

class CategorySearchViewController: BaseViewController, CategorySearchView, Navigatable {
    
    var navigator: Navigator!
    let presenter: CategorySearchPresenter
    private let searchDataSource: CategorySearchDataSource
    
    // @IBOutlet
    @IBOutlet weak private var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var searchTextField: TextField!
    @IBOutlet weak private var resultTableView: UITableView!
    
    // @IBAction
    @IBAction private func backButtonTap(_ sender: Any) {
        back()
    }
    
    init(navigator: Navigator,
         presenter: CategorySearchPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.searchDataSource = CategorySearchDataSource(presenter: self.presenter)
        super.init(nibName: CategorySearchViewController.className, bundle: Bundle(for: CategorySearchViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        presenter.view = self
        presenter.viewDidLoad()
        
        searchTextField.delegate = self
        searchDataSource.configure(with: resultTableView)
    }
    
    deinit {
        unregisterNotifications()
    }
}

// MARK: - UI Logic
extension CategorySearchViewController {
    func reloadTableView() {
        resultTableView.reloadData()
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
        tableViewBottomConstraint.constant = keyboardInfo.frame.size.height
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
        tableViewBottomConstraint.constant = 10
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}

// MARK: - Navigation
extension CategorySearchViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
}

// MARK: - UITextFieldDelegate
extension CategorySearchViewController: UITextFieldDelegate {
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
