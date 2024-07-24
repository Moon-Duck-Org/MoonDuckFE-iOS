//
//  HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation

protocol HomePresenter: AnyObject {
    var view: HomeView? { get set }
    
    /// Data
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    var numberOfReviews: Int { get }
    var sortTitles: [String] { get }
    
    func category(at index: Int) -> Category?
    func review(at index: Int) -> Review?
    func reviewOptionHandler(for review: Review) -> (() -> Void)?
    func writeReviewHandler(for review: Review) -> (() -> Void)?
    func shareReviewHandler(for review: Review) -> (() -> Void)?
    func deleteReviewHandler(for review: Review) -> (() -> Void)?
    func reviewTappedHandler(for review: Review) -> (() -> Void)?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func selectCategory(at index: Int)
    func selectSort(at index: Int)
    func selectReview(at index: Int)
    func myButtonTapped()
    func writeNewReviewButtonTapped()
    func refreshReviews()
    func loadNextReviews()
}

class HomeViewPresenter: BaseViewPresenter, HomePresenter {
    
    weak var view: HomeView?
    private let userModel: UserModelType
    private let categoryModel: CategoryModelType
    private let sortModel: SortModelType
    private let reviewModel: ReviewListModelType
    private let shareModel: ShareModelType
    
    private var reloadCategoryTrigger: [Category] = []
    
    init(with provider: AppServices,
         userModel: UserModelType,
         categoryModel: CategoryModelType,
         sortModel: SortModelType,
         reviewModel: ReviewListModelType,
         shareModel: ShareModelType) {
        self.userModel = userModel
        self.categoryModel = categoryModel
        self.sortModel = sortModel
        self.reviewModel = reviewModel
        self.shareModel = shareModel
        super.init(with: provider)
        self.userModel.delegate = self
        self.sortModel.delegate = self
        self.categoryModel.delegate = self
        self.reviewModel.delegate = self
        self.shareModel.delegate = self
    }
    // MARK: - Data
    var numberOfCategories: Int {
        return categoryModel.numberOfCategories
    }
    
    var indexOfSelectedCategory: Int? {
        return categoryModel.indexOfSelectedCategory
    }
    
    var numberOfReviews: Int {
        let category = categoryModel.selectedCategory ?? .none
        return reviewModel.numberOfReviews(with: category)
    }
    
    var sortTitles: [String] {
        return sortModel.sortOptions.map { $0.title }
    }
    
    func category(at index: Int) -> Category? {
        return categoryModel.category(at: index)
    }
    
    func review(at index: Int) -> Review? {
        let category = categoryModel.selectedCategory ?? .none
        return reviewModel.review(with: category, at: index)
    }
    
    func reviewOptionHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            self?.view?.showOptionAlert(for: review)
        }
    }
    
    func writeReviewHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            let model = WriteReviewModel(self.provider, review: review)
            let presenter = WriteReviewViewPresenter(with: self.provider, model: model, delegate: self)
            view?.moveWriteReview(with: presenter)
        }
    }
    
    func shareReviewHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            guard let self, let reviewId = review.id else { return }
            
            self.view?.updateLoadingView(isLoading: true)
            self.shareModel.getShareUrl(with: reviewId)
        }
    }
    
    func deleteReviewHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            self?.view?.updateLoadingView(isLoading: true)
            self?.reviewModel.deleteReview(for: review)
        }
    }
    
    func reviewTappedHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            let handler = self.deleteReviewHandler(for: review)
            let model = ReviewModel(self.provider, review: review, deleteReviewHandler: handler)
            let shareModel = ShareModel(self.provider)
            let presenter = ReviewDetailViewPresenter(with: provider, model: model, shareModel: shareModel, delegate: self)
            view?.moveReviewDetail(with: presenter)
        }
    }
}

extension HomeViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        categoryModel.getCategories(isHaveAll: true)
        checkNotificationAuthorization()
        updateNotification()
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        categoryModel.selectCategory(at: index)
    }
    
    func selectSort(at index: Int) {
        sortModel.selectSortOption(index)
    }
    
    func selectReview(at index: Int) {
        if let category = categoryModel.selectedCategory,
           let review = reviewModel.review(with: category, at: index) {
            let handler = deleteReviewHandler(for: review)
            let model = ReviewModel(provider, review: review, deleteReviewHandler: handler)
            let shareModel = ShareModel(self.provider)
            let presenter = ReviewDetailViewPresenter(with: provider, model: model, shareModel: shareModel, delegate: self)
            view?.moveReviewDetail(with: presenter)
        }
    }
    
    func myButtonTapped() {
        userModel.getUser()
        
        let presenter = MyInfoViewPresenter(with: provider, model: userModel)
        view?.moveMy(with: presenter)
    }
    
    func writeNewReviewButtonTapped() {
        let model = CategoryModel()
        if let category = categoryModel.selectedCategory,
           category != .all {
            model.selectedCategory = category
        }
        let presenter = SelectProgramViewPresenter(with: provider, categoryModel: model, delegate: self)
        view?.moveSelectProgram(with: presenter)
    }
    
    func refreshReviews() {
        if let category = categoryModel.selectedCategory {
            reviewModel.reloadReviews(with: category, filter: sortModel.selectedSortOption)
        }
    }

    func loadNextReviews() {
        if let category = categoryModel.selectedCategory {
            reviewModel.loadReviews(with: category, filter: sortModel.selectedSortOption)
        }
    }
    
    // MARK: - Logic
    private func checkNotificationAuthorization() {
        AppNotification.getNotificationSettingStatus { [weak self] status in
            if status == .notDetermined {
                self?.view?.showRequestNotiAuthAlert()
            }
        }
    }
    private func updateNotification() {
        guard let user = userModel.user else { return }
        
        if user.isPush {
            AppNotification.resetAndScheduleNotification(with: user.nickname)
        } else {
            AppNotification.removeNotification()
        }
    }
    
    private func updateData(with list: ReviewList) {
        view?.updateReviewCountLabelText(with: "\(list.totalElements)")
        view?.updateEmptyReviewsViewHidden(!list.reviews.isEmpty)
    }
    
    private func isNeededReloadReviews(with category: Category) -> Bool {
        if let list = reviewModel.reviewList(with: category) {
            // 1. 리뷰 수정/삭제가 일어난 카테고리면 리로드
            if let firstIndex = reloadCategoryTrigger.firstIndex(of: category) {
                reloadCategoryTrigger.remove(at: firstIndex)
                return true
            }
            
            // 2. 선택된 정렬과 캐싱된 리스트 정렬이 다르면 리로드
            if list.sortOption != sortModel.selectedSortOption {
                return true
            }
            
            return false
        }
        return true
    }
    
    private func moveMyInfo(with model: UserModel) {
        let presenter = MyInfoViewPresenter(with: provider, model: model)
        view?.moveMy(with: presenter)
    }
    
    private func setReloadCategoryTrigger(with category: Category) {
        if !reloadCategoryTrigger.contains(category) {
            reloadCategoryTrigger.append(category)
        }
    }
}

// MARK: - UserModelDelegate
extension HomeViewPresenter: UserModelDelegate {
    func error(didRecieve error: APIError?) {
        
    }
    
    func userModelDidAuthError(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.shared.logout()
        let model = UserModel(provider)
        let presenter = LoginViewPresenter(with: provider, model: model)
        view?.showAuthErrorAlert(with: presenter)
    }
}

// MARK: - CategoryModelDelegate
extension HomeViewPresenter: CategoryModelDelegate {
    func categoryModel(_ model: CategoryModel, didChange categories: [Category]) {
        model.selectCategory(at: 0)
    }
    
    func categoryModel(_ model: CategoryModel, didSelect category: Category) {
        view?.reloadCategories()
        
        if isNeededReloadReviews(with: category) {
            // API 호출
            view?.updateLoadingView(isLoading: true)
            reviewModel.reloadReviews(with: category, filter: sortModel.selectedSortOption)
        } else {
            // 테이블 뷰만 리로드
            view?.reloadReviews()
            if let list = reviewModel.reviewList(with: category) {
                updateData(with: list)
            }
            view?.resetScrollAndEndRefresh()
        }
    }
    
    func categoryModel(_ model: CategoryModel, didReload category: Category) {
        view?.reloadCategories()
    }
}

// MARK: - SortModelDelegate
extension HomeViewPresenter: SortModelDelegate {
    func sortModel(_ model: SortModel, didSelect sortOption: Sort) {
        view?.updateSortTitleLabelText(with: sortOption.title)
        
        if let selectedCategory = categoryModel.selectedCategory {
            reviewModel.reloadReviews(with: selectedCategory, filter: sortOption)
        }
    }
    
    func sortModel(_ model: SortModel, didReload sortOption: Sort) {
        view?.updateSortTitleLabelText(with: sortOption.title)
    }
}

// MARK: - ReviewListModelDelegate
extension HomeViewPresenter: ReviewListModelDelegate {
    func reviewListModel(_ model: ReviewListModelType, didSuccess list: ReviewList) {
        view?.updateLoadingView(isLoading: false)
        
        view?.reloadReviews()
        if list.isFirst {
            // 첫 번째 리뷰 리스트면 데이터 업데이트
            updateData(with: list)
            view?.resetScrollAndEndRefresh()
        }
    }
    
    func reviewListModel(_ model: ReviewListModelType, didRecieve error: APIError?) {
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
        view?.showErrorAlert(title: L10n.Localizable.Error.title("기록 불러오기"), message: L10n.Localizable.Error.message)
    }
    
    func reviewListModel(_ model: ReviewListModelType, didDelete review: Review) {
        view?.updateLoadingView(isLoading: false)
        userModel.deleteReview(category: review.category)
        view?.popToSelf()
        
        if let category = categoryModel.selectedCategory {
            if category != review.category {
                setReloadCategoryTrigger(with: review.category)
            }
            model.syncReviewList(with: category, review: review)
        }
    }
    
    func reviewListModel(_ model: ReviewListModelType, didAync list: ReviewList) {
        view?.updateLoadingView(isLoading: false)
        view?.reloadReviews()
        updateData(with: list)
    }
    
    func reviewListDidFail(_ model: ReviewListModelType) {
        view?.showErrorAlert(title: L10n.Localizable.Error.title("기록 불러오기"), message: L10n.Localizable.Error.message)
    }
    
    func reviewListDidLast(_ model: ReviewListModelType) {
        
    }
    
    func reviewListDidFailDeleteReview(_ model: ReviewListModelType) {
        view?.showErrorAlert(title: L10n.Localizable.Error.title("기록 삭제"), message: L10n.Localizable.Error.message)
    }
}

// MARK: - ShareModelDelegate
extension HomeViewPresenter: ShareModelDelegate {
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
extension HomeViewPresenter: WriteReviewPresenterDelegate {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review) {
        view?.updateLoadingView(isLoading: false)
        view?.popToSelf()
        
        categoryModel.reloadCategory()
        sortModel.reloadSortOption()
        userModel.createReview(category: review.category)
        setReloadCategoryTrigger(with: review.category)
        if let selectedCategory = categoryModel.selectedCategory {
            view?.updateLoadingView(isLoading: true)
            reviewModel.reloadReviews(with: selectedCategory, filter: sortModel.selectedSortOption)
        }
        
        view?.showToastMessage(L10n.Localizable.Review.writeCompleteMessage)
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}

// MARK: - ReviewDetailPresenterDelegate
extension HomeViewPresenter: ReviewDetailPresenterDelegate {
    func reviewDetail(_ presenter: any ReviewDetailPresenter, didWrite review: Review) {
        categoryModel.reloadCategory()
        sortModel.reloadSortOption()
        userModel.createReview(category: review.category)
        setReloadCategoryTrigger(with: review.category)
        if let selectedCategory = categoryModel.selectedCategory {
            view?.updateLoadingView(isLoading: true)
            reviewModel.reloadReviews(with: selectedCategory, filter: sortModel.selectedSortOption)
        }
    }
}
