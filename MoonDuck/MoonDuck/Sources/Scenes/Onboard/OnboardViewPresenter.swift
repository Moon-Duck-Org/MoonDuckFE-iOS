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
    
    init(with service: AppServices) {
        self.service = service
    }
    
    func startButtonTap() {
        view?.moveNameSetting(with: service)
    }

}
