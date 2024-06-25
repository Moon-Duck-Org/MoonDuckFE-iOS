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
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func selectCategory(at index: Int)
    func selectSort(at index: Int)
    func tapMyButton()
    func tapWriteNewReviewButton()
}

class V2HomeViewPresenter: Presenter, V2HomePresenter {
    
    weak var view: V2HomeView?
    private let userModel: UserModelType
    private let categoryModel: CategoryModelType
    private let sortModel: SortModelType
    private let reviewModel: HomeReviewModelType
    
    init(with provider: AppServices,
         userModel: UserModelType,
         categoryModel: CategoryModelType,
         sortModel: SortModelType,
         reviewModel: HomeReviewModel) {
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
        return reviewModel.numberOfReviews
    }
    
    var sortTitleList: [String] {
        return sortModel.sortOptions.map { $0.title }
    }
    
    func category(at index: Int) -> Category? {
        return categoryModel.category(at: index)
    }
    
    func review(at index: Int) -> Review? {
        if index < reviewModel.numberOfReviews {
            return reviewModel.reviews[index]
        } else {
            return nil
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
    
    func tapMyButton() {
        let presenter = MyInfoViewPresenter(with: provider, model: userModel)
        view?.moveMy(with: presenter)
    }
    
    func tapWriteNewReviewButton() {
        let model = CategoryModel()
        let presenter = SelectProgramViewPresenter(with: provider, categoryModel: model, delegate: self)
        view?.moveSelectProgram(with: presenter)
    }
    
    // MARK: - Logic
}

// MARK: - UserModelDelegate
extension V2HomeViewPresenter: UserModelDelegate {
    func user(_ model: UserModel, didChange user: User) {
        
    }
    
    func user(_ model: UserModel, didRecieve error: Error?) {
        
    }
    
    func user(_ model: UserModel, didRecieve error: UserModelError) {
        
    }
}

// MARK: - CategoryModelDelegate
extension V2HomeViewPresenter: CategoryModelDelegate {
    func category(_ model: CategoryModel, didChange categories: [Category]) {
        if categories.count > 0 {
            model.selectCategory(0)
        }
    }
    
    func category(_ model: CategoryModel, didSelect category: Category?) {
        view?.reloadCategories()
        
        if let category {
            view?.updateLoadingView(true)
            reviewModel.getReviews(with: category, filter: sortModel.selectedSortOption)
        }
    }
}

// MARK: - SortModelDelegate
extension V2HomeViewPresenter: SortModelDelegate {
    func sort(_ model: SortModel, didSelect sortOption: Sort) {
        view?.updateSortTitle(sortOption.title)
        
        if let category = categoryModel.selectedCategory {
            view?.updateLoadingView(true)
            reviewModel.getReviews(with: category, filter: sortOption)
        }
    }
}

// MARK: - HomeReviewModelDelegate
extension V2HomeViewPresenter: HomeReviewModelDelegate {
    func homeReview(_ model: HomeReviewModel, didSuccess reviews: [Review], isRefresh: Bool) {
        view?.updateLoadingView(false)
        view?.reloadReviews()
        if isRefresh {
            view?.updateEmptyReviewsView(reviews.isEmpty)
            view?.updateReviewCount("\(reviews.count)")
            view?.scrollToTopReviews()
        }
    }
    
    func homeReview(_ model: HomeReviewModel, didRecieve error: APIError?) {
        view?.updateLoadingView(false)
        view?.showToast(error?.errorDescription ?? error?.localizedDescription ?? "오류 발생")
    }
}

// MARK: - WriteReviewPresenterDelegate
extension V2HomeViewPresenter: WriteReviewPresenterDelegate {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review) {
        view?.popToSelf()
        
        if let category = categoryModel.selectedCategory {
            view?.updateLoadingView(true)
            reviewModel.getReviews(with: category, filter: Sort.latestOrder)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showToast("기록 작성 완료!")
        }
    }
    
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter) {
        view?.popToSelf()
    }
}
