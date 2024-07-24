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
    private var shareModel: ShareModelType
    private weak var delegate: ReviewDetailPresenterDelegate?
    
    init(with provider: AppServices, 
         model: ReviewModelType,
         shareModel: ShareModelType,
         delegate: ReviewDetailPresenterDelegate?) {
        self.model = model
        self.shareModel = shareModel
        self.delegate = delegate
        super.init(with: provider)
        self.model.delegate = self
        self.shareModel.delegate = self
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
            guard let self, let reviewId = model.review.id else { return }
            
            self.view?.updateLoadingView(isLoading: true)
            self.shareModel.getShareUrl(with: reviewId)
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

// MARK: - ShareModelDelegate
extension ReviewDetailViewPresenter: ShareModelDelegate {
    func shareModel(_ model: ShareModelType, didSuccess url: String) {
        view?.updateLoadingView(isLoading: false)
        let shareUrlString = Constants.getSharePath(with: url)
        if let shareUrl = URL(string: shareUrlString) {
            view?.showSystemShare(with: shareUrl)
        } else {
            view?.showErrorAlert(title: L10n.Localizable.Error.title("공유"), message: L10n.Localizable.Error.message)
        }
    }
    
    func shareModel(_ model: ShareModelType, didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        if let error {
            if error.isAuthError {
                AuthManager.shared.logout()
                let model = UserModel(provider)
                let presenter = LoginViewPresenter(with: provider, model: model)
                view?.showAuthErrorAlert(with: presenter)
                return
            } else if error.isNetworkError {
                view?.showNetworkErrorAlert()
                return
            } else if error.isSystemError {
                view?.showSystemErrorAlert()
                return
            }
        }
        view?.showErrorAlert(title: L10n.Localizable.Error.title("공유"), message: L10n.Localizable.Error.message)
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
