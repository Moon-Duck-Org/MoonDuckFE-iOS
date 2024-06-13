//
//  IntroViewController.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

protocol IntroView: BaseView {
    func moveLogin(with presenter: LoginPresenter)
    func moveNameSetting(with presenter: NameSettingPresenter)
    func moveHome(with presenter: V2HomePresenter)
}

class IntroViewController: BaseViewController, IntroView, Navigatable {
    
    var navigator: Navigator!
    let presenter: IntroPresenter
    
    init(navigator: Navigator,
         presenter: IntroPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: IntroViewController.className, bundle: Bundle(for: IntroViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension IntroViewController {
    
}

// MARK: - Navigation
extension IntroViewController {
    func moveLogin(with presenter: LoginPresenter) {
        navigator.show(seque: .login(presenter: presenter), sender: nil, transition: .root)
    }
    
    func moveNameSetting(with presenter: NameSettingPresenter) {
        navigator.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root)
    }
    
    func moveHome(with presenter: V2HomePresenter) {
        navigator.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
}
