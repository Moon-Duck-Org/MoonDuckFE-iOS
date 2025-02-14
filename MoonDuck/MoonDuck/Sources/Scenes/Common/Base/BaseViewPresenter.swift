//
//  BaseViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 2/14/25.
//

import Foundation

class BaseViewPresenter: NSObject {
    let provider: AppStorages
    let model: AppModels
    
    init(with provider: AppStorages, model: AppModels) {
        self.provider = provider
        self.model = model
        super.init()
    }
}
