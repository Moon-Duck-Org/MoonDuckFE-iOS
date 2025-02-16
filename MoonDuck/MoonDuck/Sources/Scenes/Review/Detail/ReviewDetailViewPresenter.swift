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
    var review: Review? { get }
    
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
    private weak var delegate: ReviewDetailPresenterDelegate?
    
    init(with provider: AppStorages,
         model: AppModels,
         delegate: ReviewDetailPresenterDelegate?) {
        self.delegate = delegate
        super.init(with: provider, model: model)
//        self.model.reviewModel?.delegate = self
        self.model.shareModel?.delegate = self
    }
    
    // MARK: - Data
    var review: Review? {
        return nil
//        return model.reviewModel?.review
    }
    
    func writeReviewHandler() -> (() -> Void)? {
        return { [weak self] in
//            guard let self else { return }
//            AnalyticsService.shared.logEvent(.TAP_DETAIL_REVIEW_EDIT, parameters: [.CATEGORY_TYPE: review?.program.category.rawValue ?? ""])
//            
//            let appModel = AppModels(
//                writeReviewModel: WriteReviewModel(self.provider, review: review)
//            )
//            let presenter = WriteReviewViewPresenter(with: self.provider, model: appModel, delegate: self)
//            view?.moveWriteReview(with: presenter)
        }
    }
    
    func shareReviewHandler() -> (() -> Void)? {
        return { [weak self] in
//            guard let self, let reviewId = model.reviewModel?.review.id else { return }
//            AnalyticsService.shared.logEvent(.TAP_DETAIL_REVIEW_SHARE, parameters: [.CATEGORY_TYPE: review?.program.category.rawValue ?? ""])
//            
//            self.view?.updateLoadingView(isLoading: true)
//            self.model.shareModel?.getShareUrl(with: reviewId)
        }
    }
    
    func deleteReviewHandler() -> (() -> Void)? {
//        if let deleteReviewHandler = model.reviewModel?.deleteReviewHandler {
//            return { [weak self] in
//                guard let self else { return }
//                AnalyticsService.shared.logEvent(.TAP_DETAIL_REVIEW_DELETE, parameters: [.CATEGORY_TYPE: review?.program.category.rawValue ?? ""])
//                
//                view?.updateLoadingView(isLoading: true)
//                deleteReviewHandler()
//            }
//        } else {
//            return model.reviewModel?.deleteReviewHandler
//        }
        return nil
    }
    
}

extension ReviewDetailViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(
            .VIEW_REVIEW_DETAIL,
            parameters: [.CATEGORY_TYPE: review?.program.category.rawValue ?? ""]
        )
        
        if let review {
            view?.updateData(for: review)
        }
    }
    
    // MARK: - Action
    func selectReviewImage(_ index: Int) {
//        if let review, index < review.imageUrlList.count {
//            let imageUrls = review.imageUrlList
//            let presenter = ReviewDetailImageViewPresenter(with: provider, imageUrls: imageUrls, currentIndex: index)
//            view?.moveDetailImage(with: presenter)
//        }
    }
    
    // MARK: - Logic
}

// MARK: - ReviewModelDelegate
//extension ReviewDetailViewPresenter: ReviewModelDelegate {
//    func reviewModel(_ model: ReviewModelType, didSuccess review: Review) {
//        view?.updateData(for: review)
//    }
//    
//    func reviewModel(_ model: ReviewModelType, didRecieve error: APIError?) {
//        
//    }
//}

// MARK: - ShareModelDelegate
extension ReviewDetailViewPresenter: ShareModelDelegate {
    func shareModel(_ model: ShareModelType, didSuccess url: String) {
        view?.updateLoadingView(isLoading: false)
        let shareUrlString = Constants.getSharePath(with: url)
        if let shareUrl = URL(string: shareUrlString) {
            AnalyticsService.shared.logEvent(.SUCCESS_REVIEW_SHARE, parameters: [.SHARE_URL: shareUrlString])
            view?.showSystemShare(with: shareUrl)
        } else {
            view?.showErrorAlert(title: L10n.Localizable.Error.title("공유"), message: L10n.Localizable.Error.message)
        }
    }
    
    func shareModel(_ model: ShareModelType, didRecieve error: APIError?) {
//        view?.updateLoadingView(isLoading: false)
//        if let error {
//            if error.isAuthError {
//                AuthManager.shared.logout()
//                let appModel = AppModels(
//                    userModel: UserModel(provider)
//                )
//                let presenter = LoginViewPresenter(with: provider, model: appModel)
//                view?.showAuthErrorAlert(with: presenter)
//                return
//            } else if error.isNetworkError {
//                view?.showNetworkErrorAlert()
//                return
//            } else if error.isSystemError {
//                view?.showSystemErrorAlert()
//                return
//            }
//        }
//        view?.showErrorAlert(title: L10n.Localizable.Error.title("공유"), message: L10n.Localizable.Error.message)
    }
}

// MARK: - WriteReviewPresenterDelegate
extension ReviewDetailViewPresenter: WriteReviewPresenterDelegate {
    func writeReview(_ presenter: any WriteReviewPresenter, didSuccess review: RealmReview, isNewWrite: Bool) {
        view?.updateLoadingView(isLoading: false)
        
//        delegate?.reviewDetail(self, didWrite: review)
        view?.popToSelf()
//        model.reviewModel?.save(for: review)
        
        view?.showToastMessage(L10n.Localizable.Review.writeCompleteMessage)
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}
