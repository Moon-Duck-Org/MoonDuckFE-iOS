//
//  V2HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation

protocol V2HomePresenter: AnyObject {
    var view: V2HomeView? { get set }
    
    /// Life Cycle
    
    /// Action
    func myButtonTap()
    
    /// Data
}

class V2HomeViewPresenter: Presenter, V2HomePresenter {
    
    weak var view: V2HomeView?
}

// MARK: - Input
extension V2HomeViewPresenter {
    func myButtonTap() {
        
    }
    
}

// MARK: - Networking
extension V2HomeViewPresenter {
    
}
