//
//  NameSettingViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation

protocol NameSettingPresenter: AnyObject {
    var view: NameSettingView? { get set }
    var service: AppServices { get }
    func completeButtonTap()
}

class NameSettingViewPresenter: NameSettingPresenter {
    
    weak var view: NameSettingView?
    
    let service: AppServices
    
    init(with service: AppServices) {
        self.service = service
    }
    
    func completeButtonTap() {
        view?.moveHome(with: service)
    }
    
}
