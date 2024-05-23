//
//  IntroViewController.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

protocol IntroView: AnyObject {
    func moveHome()
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
