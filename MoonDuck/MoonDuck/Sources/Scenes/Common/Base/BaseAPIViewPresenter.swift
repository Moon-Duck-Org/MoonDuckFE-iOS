//
//  BaseViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/3/24.
//

// MARK: - API Version

import Foundation

class BaseAPIViewPresenter: NSObject {
    let provider: AppServices
    let model: APIAppModels
    
    init(with provider: AppServices, model: APIAppModels) {
        self.provider = provider
        self.model = model
        super.init()
    }
}
