//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    var service: AppServices { get }
    func viewDidLoad()
}

class IntroViewPresenter: IntroPresenter {
    
    weak var view: IntroView?
    
    let service: AppServices
    
    init(with service: AppServices) {
        self.service = service
    }
    
    func viewDidLoad() {
        view?.moveOnboard(with: service)
    }
}
