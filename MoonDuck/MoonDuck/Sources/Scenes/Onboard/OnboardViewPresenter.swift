//
//  OnboardViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation
protocol OnboardPresenter: AnyObject {
    var view: OnboardView? { get set }
    var userService: UserService { get }
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}

class OnboardViewPresenter: OnboardPresenter {
    
    weak var view: OnboardView?
    
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
