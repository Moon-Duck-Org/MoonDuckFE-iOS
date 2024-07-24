//
//  BaseViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/3/24.
//

import Foundation

protocol BasePresenter: AnyObject {
    
}

class BaseViewPresenter: NSObject {
    let provider: AppServices
    let model: AppModels
    
    init(with provider: AppServices, model: AppModels) {
        self.provider = provider
        self.model = model
        super.init()
    }
}
