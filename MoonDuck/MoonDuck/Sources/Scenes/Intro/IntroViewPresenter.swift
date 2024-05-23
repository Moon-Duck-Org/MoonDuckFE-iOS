//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
}

class IntroViewPresenter {
    weak var view: IntroView?
    
    
}
