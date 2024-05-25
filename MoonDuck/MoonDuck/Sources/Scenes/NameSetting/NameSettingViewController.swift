//
//  NameSettingViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit
import Combine

protocol NameSettingView: AnyObject {
    func moveHome(with service: AppServices, user: User)
    func completeButtonTap()
    func showErrorText(_ hint: String)
    func updateCountText(_ cnt: Int)
    func updateCompleteButton(isEnabled: Bool)
}

class NameSettingViewController: UIViewController, NameSettingView, Navigatable {
    
    @IBOutlet weak private var completeButton: UIButton!
    @IBOutlet weak private var nameTextField: TextField!
    @IBOutlet weak private var hintLabel: UILabel!
    @IBOutlet weak private var cntLabel: UILabel!
    
    @IBAction private func completeButtonTap(_ sender: Any) {
        presenter.completeButtonTap()
    }
    
    let presenter: NameSettingPresenter
    var navigator: Navigator!
    
    init(navigator: Navigator,
         presenter: NameSettingPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: NameSettingViewController.className, bundle: Bundle(for: NameSettingViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        nameTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func completeButtonTap() {
        view.endEditing(true)
        presenter.checkValid(nameTextField.text)
    }
    
    func showErrorText(_ hint: String) {
        nameTextField.error()
        hintLabel.text = hint
    }
    
    func updateCountText(_ cnt: Int) {
        cntLabel.text = "\(cnt)/10"
    }
    
    func updateCompleteButton(isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
    }
}

// MARK: - UITextFieldDelegate
extension NameSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = nameTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return presenter.changeText(current: currentText, change: changeText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        presenter.checkValid(textField.text)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        clearErrorText()
        return true
    }
    
    private func clearErrorText() {
        nameTextField.normal()
        hintLabel.text = ""
    }
}

// MARK: - Navigation
extension NameSettingViewController {
    func moveHome(with service: AppServices, user: User) {
        let presenter = HomeViewPresenter(with: service, user: user)
        navigator.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
}
