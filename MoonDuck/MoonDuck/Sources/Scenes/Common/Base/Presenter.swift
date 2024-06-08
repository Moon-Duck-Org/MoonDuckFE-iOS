//
//  Presenter.swift
//  MoonDuck
//
//  Created by suni on 6/3/24.
//

import Foundation
import Combine

class Presenter: NSObject {
    let provider: AppServices
    let model: UserModelType
    let isLoading = PassthroughSubject<Bool, Never>()
    
    typealias DisposeBag = Set<AnyCancellable>
    var bag = DisposeBag()
    
    init(with provider: AppServices, model: UserModelType) {
        self.provider = provider
        self.model = model
        super.init()
        
        isLoading
            .sink { [weak self] isShow in
                if isShow {
                    Log.debug("Presenter isLoading", isShow)
                } else {
                    Log.debug("Presenter isLoading", isShow)
                }
            }.store(in: &bag)
    }
}
