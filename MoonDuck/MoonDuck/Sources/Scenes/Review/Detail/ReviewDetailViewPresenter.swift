//
//  ReviewDetailViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/28/24.
//

import Foundation

protocol ReviewDetailPresenter: AnyObject {
    var view: ReviewDetailView? { get set }
    
    // Data
    var review: Review { get }
    
    // Life Cycle

    // Action
}

class ReviewDetailViewPresenter: Presenter, ReviewDetailPresenter {
    weak var view: ReviewDetailView?
    
    
    init(with provider: AppServices,
         review: Review) {
        self.review = review
        super.init(with: provider)
    }
    
    // MARK: - Data
    var review: Review
}

extension ReviewDetailPresenter {
    
    // MARK: - Life Cycle
    
    // MARK: - Action
    
    // MARK: - Logic
}
