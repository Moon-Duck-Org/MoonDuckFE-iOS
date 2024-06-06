//
//  LoginViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol LoginView: AnyObject {
    func moveNameSetting(with presenter: NameSettingViewPresenter)
}

class LoginViewController: UIViewController, LoginView, Navigatable {
    
    var navigator: Navigator!
    let presenter: LoginPresenter
    
    @IBAction private func kakaoLoginButtonTap(_ sender: Any) {
        presenter.kakaoLoginButtonTap()
    }
    
    init(navigator: Navigator,
         presenter: LoginPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: LoginViewController.className, bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
    }
}

// MARK: - Navigation
extension LoginViewController {
    func moveNameSetting(with presenter: NameSettingViewPresenter) {
        navigator.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root)
    }
}
