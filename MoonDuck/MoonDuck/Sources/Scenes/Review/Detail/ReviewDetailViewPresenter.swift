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
    
    func writeReviewHandler() -> (() -> Void)?
    func shareReviewHandler() -> (() -> Void)?
    func deleteReviewHandler() -> (() -> Void)?
    
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
    
    func writeReviewHandler() -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            let model = WriteReviewModel(self.provider, review: review)
            let presenter = WriteReviewViewPresenter(with: self.provider, model: model, delegate: self)
            view?.moveWriteReview(with: presenter)
        }
    }
    
    func shareReviewHandler() -> (() -> Void)? {
        return { [weak self] in
            self?.view?.showToastMessage("공유 연동 예정")
        }
    }
    
    func deleteReviewHandler() -> (() -> Void)? {
        if let deleteReviewHandler = model.deleteReviewHandler {
            return { [weak self] in
                guard let self else { return }
                view?.updateLoadingView(isLoading: true)
                model.deleteReviewHandler?()
            }
        } else {
            return model.deleteReviewHandler
        }
    }
    
}

extension ReviewDetailViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.updateData(for: model.review)
    }
    
    // MARK: - Action
    
    // MARK: - Logic
}

// MARK: - ReviewModelDelegate
extension ReviewDetailViewPresenter: ReviewModelDelegate {
    func review(_ model: ReviewModelType, didSuccess review: Review) {
        view?.updateData(for: review)
    }
    
    func review(_ model: ReviewModelType, didRecieve error: APIError?) {
        
    }
}

// MARK: - WriteReviewPresenterDelegate
extension ReviewDetailViewPresenter: WriteReviewPresenterDelegate {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review) {
        view?.popToSelf()
        model.save(for: review)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showToastMessage("기록 작성 완료!")
        }
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}
