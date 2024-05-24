//
//  IntroViewController.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

protocol IntroView: AnyObject {
    func moveOnboard(with service: AppServices)
    func moveHome(with service: AppServices)
}

class IntroViewController: UIViewController, IntroView, Navigatable {
    
    let presenter: IntroPresenter
    var navigator: Navigator!
    
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

// MARK: - Navigation
extension IntroViewController {
    func moveHome(with service: AppServices) {
        let presenter = HomeViewPresenter(with: service)
        navigator.show(seque: .home(presentr: presenter), sender: nil, transition: .root)
    }
    
    func moveOnboard(with service: AppServices) {
        let presenter = OnboardViewPresenter(with: service)
        navigator.show(seque: .onboard(presenter: presenter), sender: nil, transition: .root)
    }
}
