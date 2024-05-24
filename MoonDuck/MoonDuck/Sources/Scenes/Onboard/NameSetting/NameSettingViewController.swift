//
//  NameSettingViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol NameSettingView: AnyObject {
    func moveHome(with service: AppServices)
}

class NameSettingViewController: UIViewController, NameSettingView, Navigatable {
    
    @IBAction func completeButtonTap(_ sender: Any) {
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
    }
}

// MARK: - Navigation
extension NameSettingViewController {
    func moveHome(with service: AppServices) {
        let presenter = HomeViewPresenter(with: service)
        navigator.show(seque: .home(presentr: presenter), sender: nil, transition: .root)
    }
}
