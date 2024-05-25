//
//  IntroViewController.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

protocol IntroView: AnyObject {
    func moveOnboard(with service: AppServices, user: JoinUser)
    func moveHome(with service: AppServices, user: User)
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
    func moveHome(with service: AppServices, user: User) {
        let presenter = HomeViewPresenter(with: service, user: user)
        navigator.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
    
    func moveOnboard(with service: AppServices, user: JoinUser) {
        let presenter = OnboardViewPresenter(with: service, user: user)
        navigator.show(seque: .onboard(presenter: presenter), sender: nil, transition: .root)
    }
}
