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
    
    init(with provider: AppServices,
         userModel: UserModelType,
         categoryModel: CategoryModelType,
         sortModel: SortModelType,
         reviewModel: ReviewListModelType) {
        self.userModel = userModel
        self.categoryModel = categoryModel
        self.sortModel = sortModel
        self.reviewModel = reviewModel
        super.init(with: provider)
        self.userModel.delegate = self
        self.sortModel.delegate = self
        self.categoryModel.delegate = self
        self.reviewModel.delegate = self
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
            self?.view?.showToastMessage("공유 연동 예정")
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
            if let category = self.categoryModel.selectedCategory {
                let handler = self.deleteReviewHandler(for: review)
                let model = ReviewModel(self.provider, review: review, deleteReviewHandler: handler)
                let presenter = ReviewDetailViewPresenter(with: provider, model: model, delegate: self)
                view?.moveReviewDetail(with: presenter)
            }
        }
    }
}

extension HomeViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        categoryModel.getCategories(isHaveAll: true)
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
            let presenter = ReviewDetailViewPresenter(with: provider, model: model, delegate: self)
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
            view?.updateLoadingView(isLoading: true)
            reviewModel.reloadReviews(with: category, filter: sortModel.selectedSortOption)
        }
    }

    func loadNextReviews() {
        if let category = categoryModel.selectedCategory {
            reviewModel.loadReviews(with: category, filter: sortModel.selectedSortOption)
        }
    }
    
    // MARK: - Logic
    private func updateData(with list: ReviewList) {
        view?.updateReviewCountLabelText(with: "\(list.totalElements)")
        view?.updateEmptyReviewsViewHidden(!list.reviews.isEmpty)
    }
    
    private func isNeededReloadReviews(with category: Category) -> Bool {
        if let list = reviewModel.reviewList(with: category),
           list.sortOption == sortModel.selectedSortOption {
            return false
        }
        return true
    }
    
    private func moveMyInfo(with model: UserModel) {
        let presenter = MyInfoViewPresenter(with: provider, model: model)
        view?.moveMy(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension HomeViewPresenter: UserModelDelegate {
    func userModelDidAuthError(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
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
                AuthManager.default.logout()
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
        view?.showErrorAlert(L10n.Localizable.Error.message("기록 불러오기"))
    }
    
    func reviewListModel(_ model: ReviewListModelType, didDelete review: Review) {
        view?.updateLoadingView(isLoading: false)
        userModel.deleteReview(category: review.category)
        view?.popToSelf()
        
        if let category = categoryModel.selectedCategory {
            model.syncReviewList(with: category, review: review)
        }
    }
    
    func reviewListModel(_ model: ReviewListModelType, didAync list: ReviewList) {
        view?.updateLoadingView(isLoading: false)
        view?.reloadReviews()
        updateData(with: list)
    }
    
    func reviewListDidFail(_ model: ReviewListModelType) {
        view?.showErrorAlert(L10n.Localizable.Error.message("기록 불러오기"))
    }
    
    func reviewListDidLast(_ model: ReviewListModelType) {
        
    }
    
    func reviewListDidFailDeleteReview(_ model: ReviewListModelType) {
        view?.showErrorAlert(L10n.Localizable.Error.message("기록 삭제"))
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
        if let selectedCategory = categoryModel.selectedCategory {
            view?.updateLoadingView(isLoading: true)
            reviewModel.reloadReviews(with: selectedCategory, filter: sortModel.selectedSortOption)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showToastMessage("기록 작성 완료!")
        }
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
        if let selectedCategory = categoryModel.selectedCategory {
            view?.updateLoadingView(isLoading: true)
            reviewModel.reloadReviews(with: selectedCategory, filter: sortModel.selectedSortOption)
        }
    }
}
