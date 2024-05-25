//
//  OnboardViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation

protocol OnboardPresenter: AnyObject {
    var view: OnboardView? { get set }
    var service: AppServices { get }
    
    func startButtonTap()
}

class OnboardViewPresenter: OnboardPresenter {
    
    weak var view: OnboardView?
    
    let service: AppServices
    private let user: JoinUser
    
    init(with service: AppServices, user: JoinUser) {
        self.service = service
        self.user = user
    }
    
    func startButtonTap() {
        view?.moveNameSetting(with: service, user: user)
    }

}
