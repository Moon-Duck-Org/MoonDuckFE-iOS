//
//  Presenter.swift
//  MoonDuck
//
//  Created by suni on 6/3/24.
//

import Foundation

class Presenter: NSObject {
    let provider: AppServices
    
    init(with provider: AppServices) {
        self.provider = provider
        super.init()
    }
}
