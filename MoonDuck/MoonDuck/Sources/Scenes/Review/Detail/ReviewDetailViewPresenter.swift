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
    func viewDidLoad()

    // Action
}

class ReviewDetailViewPresenter: Presenter, ReviewDetailPresenter {
    weak var view: ReviewDetailView?
    var model: ReviewModelType
    
    init(with provider: AppServices, model: ReviewModelType) {
        self.model = model
        super.init(with: provider)
        self.model.delegate = self
    }
    
    // MARK: - Data
    var review: Review {
        return model.review
    }
}

extension ReviewDetailViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.updateData(for: model.review)
    }
    
    // MARK: - Action
    
    // MARK: - Logic
    private func updateReviewData(with review: Review) {
        
    }
}

// MARK: - ReviewModelDelegate
extension ReviewDetailViewPresenter: ReviewModelDelegate {
    func review(_ model: ReviewModelType, didSuccess review: Review) {
        view?.updateData(for: review)
    }
    
    func review(_ model: ReviewModelType, didRecieve error: APIError?) {
        
    }
    
    func review(_ model: ReviewModelType, didDelete review: Review) {
        
    }
}
