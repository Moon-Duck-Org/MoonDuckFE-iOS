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
    func deleteReviewHandler() -> (() -> Void)?
    
    // Life Cycle
    func viewDidLoad()
    func viewWillAppear()

    // Action
    func selectReviewImage(_ index: Int)
}

class ReviewDetailViewPresenter: BaseViewPresenter, ReviewDetailPresenter {
    
    weak var view: ReviewDetailView?
    
    init(with provider: AppStorages,
         model: AppModels,
         review: Review) {
        self.review = review
        super.init(with: provider, model: model)
        self.model.reviewModel?.delegate = self
    }
    
    // MARK: - Data
    var review: Review
    
    func writeReviewHandler() -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            AnalyticsService.shared.logEvent(.TAP_DETAIL_REVIEW_EDIT, parameters: [.CATEGORY_TYPE: review.program.category.apiKey])
            
            let appModel = AppModels(
                reviewModel: ReviewModel(provider)
            )
            let presenter = WriteReviewViewPresenter(with: provider, model: appModel, program: nil, editReview: review)
            view?.moveWriteReview(with: presenter)
        }
    }
    
    func deleteReviewHandler() -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            model.reviewModel?.deleteReview(for: review)
            AnalyticsService.shared.logEvent(.TAP_DETAIL_REVIEW_DELETE, parameters: [.CATEGORY_TYPE: review.program.category.apiKey])
            view?.updateLoadingView(isLoading: true)
        }
    }
    
}

extension ReviewDetailViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(
            .VIEW_REVIEW_DETAIL,
            parameters: [.CATEGORY_TYPE: review.program.category.apiKey]
        )
        
        view?.updateData(for: review)
    }
    
    func viewWillAppear() {
        guard let id = review.id else { return }
        view?.updateLoadingView(isLoading: true)
        model.reviewModel?.getReview(id)
    }
    
    // MARK: - Action
    func selectReviewImage(_ index: Int) {
        if index < review.imagePaths.count {
            let imageUrls = review.imagePaths
            let presenter = ReviewDetailImageViewPresenter(with: provider, imageUrls: imageUrls, currentIndex: index)
            view?.moveDetailImage(with: presenter)
        }
    }
    
    // MARK: - Logic
}

// MARK: - ReviewModelDelegate
extension ReviewDetailViewPresenter: ReviewModelDelegate {
    func getReview(_ model: ReviewModelType, didSuccess review: Review) {
        view?.updateLoadingView(isLoading: false)
        view?.updateData(for: review)
    }
    
    func deleteReview(_ model: ReviewModelType, didSuccess review: Review) {
        view?.updateLoadingView(isLoading: false)
        view?.backToHome()
    }
    
    func didFailToGetReview(_ model: ReviewModelType) {
        view?.updateLoadingView(isLoading: false)
        view?.backToHome()
    }
    
    func didFailToDeleteReview(_ model: ReviewModelType) {
        view?.updateLoadingView(isLoading: false)
        view?.showErrorAlert(title: L10n.Localizable.Error.title("기록 삭제"), message: L10n.Localizable.Error.message)
    }
}

// MARK: - ShareModelDelegate
//extension ReviewDetailViewPresenter: ShareModelDelegate {
//    func shareModel(_ model: ShareModelType, didSuccess url: String) {
//        view?.updateLoadingView(isLoading: false)
//        let shareUrlString = Constants.getSharePath(with: url)
//        if let shareUrl = URL(string: shareUrlString) {
//            AnalyticsService.shared.logEvent(.SUCCESS_REVIEW_SHARE, parameters: [.SHARE_URL: shareUrlString])
//            view?.showSystemShare(with: shareUrl)
//        } else {
//            view?.showErrorAlert(title: L10n.Localizable.Error.title("공유"), message: L10n.Localizable.Error.message)
//        }
//    }
//    
//    func shareModel(_ model: ShareModelType, didRecieve error: APIError?) {
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
//    }
//}
