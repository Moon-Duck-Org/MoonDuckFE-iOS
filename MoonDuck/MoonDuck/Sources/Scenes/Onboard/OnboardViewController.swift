//
//  OnboardViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol OnboardView: AnyObject {
    func moveHome()
}

class OnboardViewController: UIViewController, OnboardView, Navigatable {
    
    let presenter: OnboardPresenter
    var navigator: Navigator!
    
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
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    func moveHome() {
        let presenter = HomeViewPresenter()
        navigator.show(seque: .home(presentr: presenter), sender: nil, transition: .root)
    }
}
