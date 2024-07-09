//
//  ReviewDetailViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/28/24.
//

import Foundation

protocol ReviewDetailPresenterDelegate: AnyObject {
    func reviewDetail(_ presenter: ReviewDetailPresenter, didWrite review: Review)
}

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
    func selectReviewImage(_ index: Int)
}

class ReviewDetailViewPresenter: BaseViewPresenter, ReviewDetailPresenter {
    
    weak var view: ReviewDetailView?
    private var model: ReviewModelType
    private var delegate: ReviewDetailPresenterDelegate?
    
    init(with provider: AppServices, 
         model: ReviewModelType,
         delegate: ReviewDetailPresenterDelegate?) {
        self.model = model
        self.delegate = delegate
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
                deleteReviewHandler()
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
    func selectReviewImage(_ index: Int) {
        if index < review.imageUrlList.count {
            let imageUrls = review.imageUrlList
            let presenter = ReviewDetailImageViewPresenter(with: provider, imageUrls: imageUrls, currentIndex: index)
            view?.moveDetailImage(with: presenter)
        }
    }
    
    // MARK: - Logic
}

// MARK: - ReviewModelDelegate
extension ReviewDetailViewPresenter: ReviewModelDelegate {
    func reviewModel(_ model: ReviewModelType, didSuccess review: Review) {
        view?.updateData(for: review)
    }
    
    func reviewModel(_ model: ReviewModelType, didRecieve error: APIError?) {
        
    }
}

// MARK: - WriteReviewPresenterDelegate
extension ReviewDetailViewPresenter: WriteReviewPresenterDelegate {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review) {
        view?.updateLoadingView(isLoading: false)
        
        delegate?.reviewDetail(self, didWrite: review)
        view?.popToSelf()
        model.save(for: review)
        
        view?.showToastMessage(L10n.Localizable.Review.writeCompleteMessage)
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}
