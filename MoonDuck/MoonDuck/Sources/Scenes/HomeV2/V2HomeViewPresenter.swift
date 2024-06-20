//
//  V2HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation

protocol V2HomePresenter: AnyObject {
    var view: V2HomeView? { get set }
    
    /// Data
    
    /// Life Cycle
    
    /// Action
    func tapMyButton()
    func tapWriteNewReviewButton()
}

class V2HomeViewPresenter: Presenter, V2HomePresenter {
    
    weak var view: V2HomeView?
    private let userModel: UserModelType
    
    init(with provider: AppServices, userModel: UserModelType) {
        self.userModel = userModel
        super.init(with: provider)
        self.userModel.delegate = self
    }
}

extension V2HomeViewPresenter {
    // MARK: - Action
    func tapMyButton() {
        let presenter = MyInfoViewPresenter(with: provider, model: userModel)
        view?.moveMy(with: presenter)
    }
    
    func tapWriteNewReviewButton() {
//        let presenter = WriteReviewViewPresenter(with: provider)
//        view?.moveWriteReview(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension V2HomeViewPresenter: UserModelDelegate {
    func user(_ model: UserModel, didChange user: User) {
        
    }
    
    func user(_ model: UserModel, didRecieve error: Error?) {
        
    }
    
    func user(_ model: UserModel, didRecieve error: UserModelError) {
        
    }
}
