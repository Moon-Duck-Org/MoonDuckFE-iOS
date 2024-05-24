//
//  OnboardViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol OnboardView: AnyObject {
    func moveHome(with service: AppServices)
    func moveNameSetting(with service: AppServices)
}

class OnboardViewController: UIViewController, OnboardView, Navigatable {
        
    let presenter: OnboardPresenter
    var navigator: Navigator!
    
    @IBAction private func startButtonTap(_ sender: Any) {
        presenter.startButtonTap()
    }
    
    init(navigator: Navigator,
         presenter: OnboardPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: OnboardViewController.className, bundle: Bundle(for: OnboardViewController.self))
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
extension OnboardViewController {
    func moveHome(with service: AppServices) {
        let presenter = HomeViewPresenter(with: service)
        navigator.show(seque: .home(presentr: presenter), sender: nil, transition: .root)
    }
    
    func moveNameSetting(with service: AppServices) {
        let presenter = NameSettingViewPresenter(with: service)
        navigator.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root)
    }
}
