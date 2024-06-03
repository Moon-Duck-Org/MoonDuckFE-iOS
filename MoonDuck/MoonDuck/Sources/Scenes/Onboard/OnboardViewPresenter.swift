//
//  OnboardViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation

protocol OnboardPresenter: AnyObject {
    var view: OnboardView? { get set }
    
    func startButtonTap()
}

class OnboardViewPresenter: Presenter, OnboardPresenter {
    
    weak var view: OnboardView?
    
    private let joinUser: JoinUser
    
    init(with provider: AppServices, joinUser: JoinUser) {
        self.joinUser = joinUser
        super.init(with: provider)
    }
    
    func startButtonTap() {
        let presenter = NameSettingViewPresenter(with: provider, joinUser: joinUser)
        view?.moveNameSetting(with: presenter)
    }
}
