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
    func myButtonTap()
    func writeNewReviewButtonTap()
}

class V2HomeViewPresenter: Presenter, V2HomePresenter {
    
    weak var view: V2HomeView?
    let userModel: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.userModel = model
        super.init(with: provider)
    }
}

extension V2HomeViewPresenter {
    // MARK: - Action
    func myButtonTap() {
        let presenter = MyInfoViewPresenter(with: provider, model: userModel)
        view?.moveMy(with: presenter)
    }
    func writeNewReviewButtonTap() {
        let model = ReviewCategoryModel()
        let presenter = WriteReviewCategoryViewPresenter(with: provider, model: model)
        view?.moveWriteReviewCategory(with: presenter)
    }
}

// MARK: - Networking
extension V2HomeViewPresenter {
    
}
