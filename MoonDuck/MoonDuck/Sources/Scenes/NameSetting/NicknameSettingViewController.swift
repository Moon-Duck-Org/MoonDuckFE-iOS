//
//  NicknameSettingViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol NicknameSettingView: BaseView {
    // UI Logic
    func updateCancelButtonHidden(_ isHidden: Bool)
    func updateHintLabelText(with text: String?)
    func updateNameTextFieldText(with text: String)
    func updateCountLabelText(with text: String)
    func updateCompleteButtonEnabled(_ isEnabled: Bool)
    
    // Navigation
    func dismiss()
    func moveHome(with presenter: HomePresenter)
}

class NicknameSettingViewController: BaseViewController, NicknameSettingView {
    
    let presenter: NicknameSettingPresenter
    
    // @IBOutlet
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private weak var nicknameTextField: TextField!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    // IBAction
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss()
    }
    @IBAction private func completeButtonTapped(_ sender: Any) {
        throttler.throttle {
            self.view.endEditing(true)
            self.presenter.completeButtonTapped()
        }
    }
    
    @IBAction private func nameTextFieldEditingChanged(_ sender: Any) {
        presenter.nicknameTextFieldEditingChanged(nicknameTextField.text)
    }
    
    init(navigator: Navigator,
         presenter: NicknameSettingPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: NicknameSettingViewController.className, bundle: Bundle(for: NicknameSettingViewController.self))
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
    func updateCancelButtonHidden(_ isHidden: Bool) {
        cancelButton.isHidden = isHidden
    }
    
    func updateHintLabelText(with text: String?) {
        if let text, text.isEmpty {
            nicknameTextField.normal()
            hintLabel.text = ""
        } else {
            nicknameTextField.error()
            hintLabel.text = text
        }
    }
    
    func updateNameTextFieldText(with text: String) {
        nicknameTextField.text = text
    }
    
    func updateCountLabelText(with text: String) {
        countLabel.text = text
    }
    
    func updateCompleteButtonEnabled(_ isEnabled: Bool) {
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
    
    func moveHome(with presenter: HomePresenter) {
        navigator?.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
}
