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
    func deleteReviewHandler(for review: Review, isHome: Bool) -> (() -> Void)?
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
    
    private var reloadCategoryTrigger: [Category] = []
    
    override init(with provider: AppServices, model: AppModels) {
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
        self.model.sortModel?.delegate = self
        self.model.categoryModel?.delegate = self
        self.model.reviewListModel?.delegate = self
        self.model.shareModel?.delegate = self
    }
    // MARK: - Data
    var numberOfCategories: Int {
        return model.categoryModel?.numberOfCategories ?? 0
    }
    
    var indexOfSelectedCategory: Int? {
        return model.categoryModel?.indexOfSelectedCategory
    }
    
    var numberOfReviews: Int {
        let category = model.categoryModel?.selectedCategory ?? .none
        return model.reviewListModel?.numberOfReviews(with: category) ?? 0
    }
    
    var sortTitles: [String] {
        return model.sortModel?.sortOptions.map { $0.title } ?? []
    }
    
    func category(at index: Int) -> Category? {
        return model.categoryModel?.category(at: index)
    }
    
    func review(at index: Int) -> Review? {
        let category = model.categoryModel?.selectedCategory ?? .none
        return model.reviewListModel?.review(with: category, at: index)
    }
    
    func reviewOptionHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            self?.view?.showOptionAlert(for: review)
        }
    }
    
    func writeReviewHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            AnalyticsService.shared.logEvent(.TAP_HOME_REVIEW_EDIT, parameters: [.CATEGORY_TYPE: review.category.rawValue])
            
            let appModel = AppModels(
                writeReviewModel: WriteReviewModel(self.provider, review: review)
            )
            let presenter = WriteReviewViewPresenter(with: self.provider, model: appModel, delegate: self)
            view?.moveWriteReview(with: presenter)
        }
    }
    
    func shareReviewHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            guard let self, let reviewId = review.id else { return }
            AnalyticsService.shared.logEvent(.TAP_HOME_REVIEW_SHARE, parameters: [.CATEGORY_TYPE: review.category.rawValue])
            
            self.view?.updateLoadingView(isLoading: true)
            self.model.shareModel?.getShareUrl(with: reviewId)
        }
    }
    
    func deleteReviewHandler(for review: Review, isHome: Bool = true) -> (() -> Void)? {
        return { [weak self] in
            if isHome {
                AnalyticsService.shared.logEvent(.TAP_HOME_REVIEW_DELETE, parameters: [.CATEGORY_TYPE: review.category.rawValue])
            }
            self?.view?.updateLoadingView(isLoading: true)
            self?.model.reviewListModel?.deleteReview(for: review)
        }
    }
    
    func reviewTappedHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            guard let self else { return }
            let handler = self.deleteReviewHandler(for: review, isHome: false)
            let appModel = AppModels(
                reviewModel: ReviewModel(self.provider, review: review, deleteReviewHandler: handler),
                shareModel: ShareModel(self.provider)
            )
            let presenter = ReviewDetailViewPresenter(with: provider, model: appModel, delegate: self)
            view?.moveReviewDetail(with: presenter)
        }
    }
}

extension HomeViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(.VIEW_HOME, parameters: [.REVIEW_COUNT: model.userModel?.user?.all ?? 0])
        model.categoryModel?.getCategories(isHaveAll: true)
        Utils.requestTrackingAuthorization { [weak self] in
            self?.checkNotificationAuthorization()
            self?.updateNotification()
        }
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        let categoryType = model.categoryModel?.category(at: index)?.rawValue
        AnalyticsService.shared.logEvent(.TAP_HOME_CATEGORY, parameters: [.CATEGORY_TYPE: categoryType ?? ""])
        
        model.categoryModel?.selectCategory(at: index)
    }
    
    func selectSort(at index: Int) {
        let sortType = model.sortModel?.sortOption(at: index)?.rawValue
        AnalyticsService.shared.logEvent(.TAP_HOME_SORT, parameters: [.SORT_TYPE: sortType ?? ""])
        
        model.sortModel?.selectSortOption(index)
    }
    
    func selectReview(at index: Int) {
        if let category = model.categoryModel?.selectedCategory,
           let review = model.reviewListModel?.review(with: category, at: index) {
            let handler = deleteReviewHandler(for: review, isHome: false)
            let appModel = AppModels(
                reviewModel: ReviewModel(provider, review: review, deleteReviewHandler: handler),
                shareModel: ShareModel(provider)
            )
            let presenter = ReviewDetailViewPresenter(with: provider, model: appModel, delegate: self)
            view?.moveReviewDetail(with: presenter)
        }
    }
    
    func myButtonTapped() {
        model.userModel?.getUser()
        
        let appModel = AppModels(
            userModel: model.userModel
        )
        let presenter = MyInfoViewPresenter(with: provider, model: appModel)
        view?.moveMy(with: presenter)
    }
    
    func writeNewReviewButtonTapped() {
        let categoryModel = CategoryModel()
        if let selectedCategory = model.categoryModel?.selectedCategory,
           selectedCategory != .all {
            categoryModel.selectedCategory = selectedCategory
        }
        let appModel = AppModels(
            categoryModel: categoryModel
        )
        let presenter = SelectProgramViewPresenter(with: provider, model: appModel, delegate: self)
        view?.moveSelectProgram(with: presenter)
    }
    
    func refreshReviews() {
        if let category = model.categoryModel?.selectedCategory {
            model.reviewListModel?.reloadReviews(with: category, filter: model.sortModel?.selectedSortOption ?? .latestOrder)
        }
    }

    func loadNextReviews() {
        if let category = model.categoryModel?.selectedCategory {
            model.reviewListModel?.loadReviews(with: category, filter: model.sortModel?.selectedSortOption ?? .latestOrder)
        }
    }
    
    // MARK: - Logic
    private func incrementWriteReviewCount() {
        let currentCount = AppUserDefaults.getObject(forKey: .writeReviewCount) as? Int ?? 0
        let newCount = currentCount + 1
        AppUserDefaults.set(newCount, forKey: .writeReviewCount)
        
        if newCount == 3 {
            Utils.requestAppReview()
        }
    }
        
    private func checkNotificationAuthorization() {
        AppNotification.getNotificationSettingStatus { [weak self] status in
            if status == .notDetermined {
                self?.view?.showRequestNotiAuthAlert()
            }
        }
    }
    
    private func updateNotification() {
        guard let user = model.userModel?.user else { return }
        
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
        if let list = model.reviewListModel?.reviewList(with: category) {
            // 1. 리뷰 수정/삭제가 일어난 카테고리면 리로드
            if let firstIndex = reloadCategoryTrigger.firstIndex(of: category) {
                reloadCategoryTrigger.remove(at: firstIndex)
                return true
            }
            
            // 2. 선택된 정렬과 캐싱된 리스트 정렬이 다르면 리로드
            if list.sortOption != model.sortModel?.selectedSortOption {
                return true
            }
            
            return false
        }
        return true
    }
    
    private func moveMyInfo(with userModel: UserModel) {
        let appModel = AppModels(
            userModel: userModel
        )
        let presenter = MyInfoViewPresenter(with: provider, model: appModel)
        view?.moveMy(with: presenter)
    }
    
    private func setReloadCategoryTrigger(with category: Category) {
        if !reloadCategoryTrigger.contains(category) {
            reloadCategoryTrigger.append(category)
        }
    }
    
    private func reloadData(with review: Review) {
        model.categoryModel?.reloadCategory()
        model.sortModel?.reloadSortOption()
        model.userModel?.createReview(category: review.category)
        setReloadCategoryTrigger(with: review.category)
        if let selectedCategory = model.categoryModel?.selectedCategory {
            view?.updateLoadingView(isLoading: true)
            model.reviewListModel?.reloadReviews(with: selectedCategory, filter: model.sortModel?.selectedSortOption ?? .latestOrder)
        }
    }
}

// MARK: - UserModelDelegate
extension HomeViewPresenter: UserModelDelegate {
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        
        guard let error else { return }
        
        if error.isAuthError {
            AuthManager.shared.logout()
            let appModel = AppModels(
                userModel: UserModel(provider)
            )
            let presenter = LoginViewPresenter(with: provider, model: appModel)
            view?.showAuthErrorAlert(with: presenter)
        } else if error.isNetworkError {
            view?.showNetworkErrorAlert()
        } else if error.isSystemError {
            view?.showSystemErrorAlert()
        } else {
            view?.showSystemErrorAlert()
        }
    }
}

// MARK: - CategoryModelDelegate
extension HomeViewPresenter: CategoryModelDelegate {
    func categoryModel(_ model: CategoryModelType, didChange categories: [Category]) {
        model.selectCategory(at: 0)
    }
    
    func categoryModel(_ model: CategoryModelType, didSelect category: Category) {
        view?.reloadCategories()
        
        if isNeededReloadReviews(with: category) {
            // API 호출
            view?.updateLoadingView(isLoading: true)
            self.model.reviewListModel?.reloadReviews(with: category, filter: self.model.sortModel?.selectedSortOption ?? .latestOrder)
        } else {
            // 테이블 뷰만 리로드
            view?.reloadReviews()
            if let list = self.model.reviewListModel?.reviewList(with: category) {
                updateData(with: list)
            }
            view?.resetScrollAndEndRefresh()
        }
    }
    
    func categoryModel(_ model: CategoryModelType, didReload category: Category) {
        view?.reloadCategories()
    }
}

// MARK: - SortModelDelegate
extension HomeViewPresenter: SortModelDelegate {
    func sortModel(_ model: SortModel, didSelect sortOption: Sort) {
        view?.updateSortTitleLabelText(with: sortOption.title)
        
        if let selectedCategory = self.model.categoryModel?.selectedCategory {
            self.model.reviewListModel?.reloadReviews(with: selectedCategory, filter: sortOption)
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
    
    func reviewListModel(_ model: ReviewListModelType, didDelete review: Review) {
        view?.updateLoadingView(isLoading: false)
        
        self.model.userModel?.deleteReview(category: review.category)
        view?.popToSelf()
        
        if let category = self.model.categoryModel?.selectedCategory {
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
            AnalyticsService.shared.logEvent(.SUCCESS_REVIEW_SHARE, parameters: [.SHARE_URL: shareUrlString])
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
                let appModel = AppModels(
                    userModel: UserModel(provider)
                )
                let presenter = LoginViewPresenter(with: provider, model: appModel)
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
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review, isNewWrite: Bool) {
        view?.updateLoadingView(isLoading: false)
        view?.popToSelf()
        
        reloadData(with: review)
        view?.showToastMessage(L10n.Localizable.Review.writeCompleteMessage)
        
        if isNewWrite {
            incrementWriteReviewCount()
        }
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}

// MARK: - ReviewDetailPresenterDelegate
extension HomeViewPresenter: ReviewDetailPresenterDelegate {
    func reviewDetail(_ presenter: ReviewDetailPresenter, didWrite review: Review) {
        reloadData(with: review)
    }
}
