//
//  V2HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation

protocol V2HomePresenter: AnyObject {
    var view: V2HomeView? { get set }
    
    /// Data
    var numberOfCategories: Int { get }
    var indexOfSelectedCategory: Int? { get }
    var numberOfReviews: Int { get }
    var sortTitleList: [String] { get }
    
    func category(at index: Int) -> Category?
    func review(at index: Int) -> Review?
    func reviewOptionHandler(for review: Review) -> (() -> Void)?
    func writeReviewHandler(for review: Review) -> (() -> Void)?
    func shareReviewHandler(for review: Review) -> (() -> Void)?
    func deleteReviewHandler(for review: Review) -> (() -> Void)?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func selectCategory(at index: Int)
    func selectSort(at index: Int)
    func selectReview(at index: Int)
    func tapMyButton()
    func tapWriteNewReviewButton()
    func refreshReviews()
    func loadNextReviews()
}

class V2HomeViewPresenter: Presenter, V2HomePresenter {
    
    weak var view: V2HomeView?
    private let userModel: UserModelType
    private let categoryModel: CategoryModelType
    private let sortModel: SortModelType
    private let reviewModel: ReviewListModelType
    private var isMyInfoTapped: Bool = false
    
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
    
    var sortTitleList: [String] {
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
            self?.view?.showToast("공유 연동 예정")
        }
    }
    
    func deleteReviewHandler(for review: Review) -> (() -> Void)? {
        return { [weak self] in
            self?.view?.updateLoadingView(true)
            self?.reviewModel.deleteReview(for: review)
        }
    }
}

extension V2HomeViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        categoryModel.getCategories(isHaveAll: true)
    }
    
    // MARK: - Action
    func selectCategory(at index: Int) {
        categoryModel.selectCategory(index)
    }
    
    func selectSort(at index: Int) {
        sortModel.selectSortOption(index)
    }
    
    func selectReview(at index: Int) {
        view?.showToast("기록 상세 이동 예정")
    }
    
    func tapMyButton() {
        isMyInfoTapped = true
        userModel.getUser()
    }
    
    func tapWriteNewReviewButton() {
        let model = CategoryModel()
        let presenter = SelectProgramViewPresenter(with: provider, categoryModel: model, delegate: self)
        view?.moveSelectProgram(with: presenter)
    }
    
    func refreshReviews() {
        if let category = categoryModel.selectedCategory {
            view?.updateLoadingView(true)
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
        view?.updateReviewCount("\(list.totalElements)")
        view?.updateEmptyReviewsView(list.reviews.isEmpty)
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
extension V2HomeViewPresenter: UserModelDelegate {
    func user(_ model: UserModel, didChange user: User) {
        if isMyInfoTapped {
            isMyInfoTapped = false
            moveMyInfo(with: model)
        }
    }
    
    func user(_ model: UserModel, didRecieve error: Error?) {
        if isMyInfoTapped {
            isMyInfoTapped = false
            moveMyInfo(with: model)
        }
    }
    
    func user(_ model: UserModel, didRecieve error: UserModelError) {
        if isMyInfoTapped {
            isMyInfoTapped = false
            moveMyInfo(with: model)
        }
    }
}

// MARK: - CategoryModelDelegate
extension V2HomeViewPresenter: CategoryModelDelegate {
    func category(_ model: CategoryModel, didChange categories: [Category]) {
        model.selectCategory(0)
    }
    
    func category(_ model: CategoryModel, didSelect category: Category) {
        view?.reloadCategories()
        
        if isNeededReloadReviews(with: category) {
            // API 호출
            view?.updateLoadingView(true)
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
    
    func category(_ model: CategoryModel, didReload category: Category) {
        view?.reloadCategories()
    }
}

// MARK: - SortModelDelegate
extension V2HomeViewPresenter: SortModelDelegate {
    func sort(_ model: SortModel, didSelect sortOption: Sort) {
        view?.updateSortTitle(sortOption.title)
        
        if let selectedCategory = categoryModel.selectedCategory {
            reviewModel.reloadReviews(with: selectedCategory, filter: sortOption)
        }
    }
    
    func sort(_ model: SortModel, didReload sortOption: Sort) {
        view?.updateSortTitle(sortOption.title)
    }
}

// MARK: - ReviewListModelDelegate
extension V2HomeViewPresenter: ReviewListModelDelegate {
    func reviewList(_ model: ReviewListModelType, didSuccess list: ReviewList) {
        view?.updateLoadingView(false)
        
        view?.reloadReviews()
        if list.isFirst {
            // 첫 번째 리뷰 리스트면 데이터 업데이트
            updateData(with: list)
            view?.resetScrollAndEndRefresh()
        }
    }
    
    func reviewList(_ model: ReviewListModelType, didRecieve error: APIError?) {
        view?.updateLoadingView(false)
        
        if let error = error {
            view?.showToast(error.errorDescription ?? error.localizedDescription)
        }
    }
    
    func reviewList(_ model: ReviewListModelType, didDelete review: Review) {
        userModel.deleteReview(category: review.category)
        if let category = categoryModel.selectedCategory {
            model.syncReviewList(with: category, review: review)
        }
    }
    
    func reviewList(_ model: ReviewListModelType, didAync list: ReviewList) {
        view?.updateLoadingView(false)
        view?.reloadReviews()
        updateData(with: list)
    }
}

// MARK: - WriteReviewPresenterDelegate
extension V2HomeViewPresenter: WriteReviewPresenterDelegate {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review) {
        view?.popToSelf()
        
        categoryModel.reloadCategory()
        sortModel.reloadSortOption()
        userModel.createReview(category: review.category)
        if let selectedCategory = categoryModel.selectedCategory {
            view?.updateLoadingView(true)
            reviewModel.reloadReviews(with: selectedCategory, filter: sortModel.selectedSortOption)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showToast("기록 작성 완료!")
        }
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}
