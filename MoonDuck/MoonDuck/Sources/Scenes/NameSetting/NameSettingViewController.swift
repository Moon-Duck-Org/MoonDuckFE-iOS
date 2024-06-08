//
//  NameSettingViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit
import Combine

protocol NameSettingView: AnyObject {
    func showToast(_ message: String)
    func showHintLabel(_ hint: String)
    func clearHintLabel()
    func updateCountLabel(_ cnt: Int)
    func updateCompleteButton(_ isEnabled: Bool)
    
    func moveHome(with presenter: V2HomeViewPresenter)
}

class NameSettingViewController: UIViewController, NameSettingView, Navigatable {
    
    var navigator: Navigator!
    let presenter: NameSettingPresenter
    
    // @IBOutlet
    @IBOutlet weak private var completeButton: UIButton!
    @IBOutlet weak private var nameTextField: TextField!
    @IBOutlet weak private var hintLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    
    // IBAction
    @IBAction private func completeButtonTap(_ sender: Any) {
        view.endEditing(true)
        presenter.completeButtonTap()
    }
    
    @IBAction private func nameTextFieldDidChanges(_ sender: Any) {
        presenter.nameTextFieldDidChanges(nameTextField.text)
    }
    
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
        presenter.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UI Logic
extension NameSettingViewController {
    func showToast(_ message: String) {
        showToast(message: message)
    }
    
    func showHintLabel(_ hint: String) {
        nameTextField.error()
        hintLabel.text = hint
    }
    
    func clearHintLabel() {
        nameTextField.normal()
        hintLabel.text = ""
    }
    
    func updateCountLabel(_ count: Int) {
        countLabel.text = "\(count)/10"
    }
    
    func updateCompleteButton(_ isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
    }
}

// MARK: - UITextFieldDelegate
extension NameSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = nameTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return presenter.isShouldChangeName(changeText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.textFieldDidEndEditing()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        clearHintLabel()
        return true
    }
}

// MARK: - Navigation
extension NameSettingViewController {
    func moveHome(with presenter: V2HomeViewPresenter) {
        navigator.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
}
