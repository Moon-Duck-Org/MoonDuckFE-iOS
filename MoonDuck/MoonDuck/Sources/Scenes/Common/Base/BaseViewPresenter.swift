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
    
    init(with provider: AppServices) {
        self.provider = provider
        super.init()
    }
}
