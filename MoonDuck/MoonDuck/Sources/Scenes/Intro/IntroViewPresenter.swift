//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}

class IntroViewPresenter: IntroPresenter {
    
    weak var view: IntroView?
    
    let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func viewDidLoad() {
        view?.moveHome()
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
}
