//
//  SettingViewPrsenter.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

protocol SettingPresenter: AnyObject {
    var view: SettingView? { get set }
    
    // Data
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    
}

class SettingViewPrsenter: Presenter, SettingPresenter {
    weak var view: SettingView?
    
    // MARK: - Data
    
}

extension SettingViewPrsenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        
    }
    
    // MARK: - Action
    
    // MARK: - Logic
}
