//
//  NicknameSettingViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol NicknameSettingView: BaseView {
    // UI Logic
    func updateCancelButton(_ isHidden: Bool)
    func updateHintLabel(_ text: String?)
    func updateNameTextfield(_ text: String)
    func updateCountLabel(_ text: String)
    func updateCompleteButton(_ isEnabled: Bool)
    
    // Navigation
    func dismiss()
    func moveLogin(with presenter: LoginPresenter)
    func moveHome(with presenter: V2HomePresenter)
}

class NicknameSettingViewController: BaseViewController, NicknameSettingView, Navigatable {
    
    var navigator: Navigator?
    let presenter: NicknameSettingPresenter
    
    // @IBOutlet
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var completeButton: UIButton!
    @IBOutlet weak private var nicknameTextField: TextField!
    @IBOutlet weak private var hintLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    
    // IBAction
    @IBAction private func tapCancelButton(_ sender: Any) {
        dismiss()
    }
    @IBAction private func tapCompleteButton(_ sender: Any) {
        view.endEditing(true)
        presenter.tapCompleteButton()
    }
    
    @IBAction private func nameTextFieldEditingChanged(_ sender: Any) {
        presenter.nicknameTextFieldEditingChanged(nicknameTextField.text)
    }
    
    init(navigator: Navigator,
         presenter: NicknameSettingPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: NicknameSettingViewController.className, bundle: Bundle(for: NicknameSettingViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        nicknameTextField.delegate = self
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension NicknameSettingViewController {
    func updateCancelButton(_ isHidden: Bool) {
        cancelButton.isHidden = isHidden
    }
    
    func updateHintLabel(_ text: String?) {
        if let text, text.isEmpty {
            nicknameTextField.normal()
            hintLabel.text = ""
        } else {
            nicknameTextField.error()
            hintLabel.text = text
        }
    }
    
    func updateNameTextfield(_ text: String) {
        nicknameTextField.text = text
    }
    
    func updateCountLabel(_ text: String) {
        countLabel.text = text
    }
    
    func updateCompleteButton(_ isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
    }
}

// MARK: - UITextFieldDelegate
extension NicknameSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return presenter.textField(textField.text, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.textFieldDidBeginEditing(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return presenter.textFieldShouldReturn(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.textFieldDidEndEditing(textField.text)
    }
}

// MARK: - Navigation
extension NicknameSettingViewController {
    func dismiss() {
        dismiss(animated: true)
    }
    
    func moveLogin(with presenter: LoginPresenter) {
        navigator?.show(seque: .login(presenter: presenter), sender: nil, transition: .root)
    }
    
    func moveHome(with presenter: V2HomePresenter) {
        navigator?.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
}
