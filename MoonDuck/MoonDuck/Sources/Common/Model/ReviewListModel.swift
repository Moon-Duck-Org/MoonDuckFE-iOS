//
//  ReviewListModel.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

protocol ReviewListModelDelegate: BaseModelDelegate {
    func reviewListModel(_ model: ReviewListModelType, didSuccess list: ReviewList)
    func reviewListModel(_ model: ReviewListModelType, didAync list: ReviewList)
    func reviewListModel(_ model: ReviewListModelType, didDelete review: Review)
    func reviewListDidFail(_ model: ReviewListModelType)
    func reviewListDidLast(_ model: ReviewListModelType)
    func reviewListDidFailDeleteReview(_ model: ReviewListModelType)
}

protocol ReviewListModelType: BaseModelType {
    // Data
    var delegate: ReviewListModelDelegate? { get set }
    
    func numberOfReviews(with category: Category) -> Int
    func review(with category: Category, at index: Int) -> Review?
    func reviewList(with category: Category) -> ReviewList?
    
    // Logic
    
    // Networking
    func loadReviews(with category: Category, filter: Sort)
    func reloadReviews(with category: Category, filter: Sort)
    func deleteReview(for review: Review)
    func syncReviewList(with category: Category, review: Review)
}

class ReviewListModel: ReviewListModelType {
    
    struct Config {
        let defaultSize: Int = 30
    }
    
    private let config: Config = Config()
    private let provider: AppServices
    private var isLoading: Bool = false
    private var reviewLists: [ReviewList] = []
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: ReviewListModelDelegate?
    
    func numberOfReviews(with category: Category) -> Int {
        return reviews(with: category).count
    }
    
    func review(with category: Category, at index: Int) -> Review? {
        let reviews = reviews(with: category)
        if index < reviews.count {
            return reviews[index]
        }
        return nil
    }
    
    func reviewList(with category: Category) -> ReviewList? {
        return reviewLists.first(where: { $0.category == category })
    }
    
    private func reviews(with category: Category) -> [Review] {
        if let reviewList = reviewList(with: category) {
            return reviewList.reviews
        }
        return []
    }
    
    private func reviewListIndex(with category: Category) -> Int? {
        return reviewLists.firstIndex(where: { $0.category == category })
    }
    
    // MARK: - Logic
    private func removeReviewList(with category: Category) {
        if let findIndex = reviewLists.firstIndex(where: { $0.category == category }) {
            reviewLists.remove(at: findIndex)
        }
    }
    
    private func saveReviewList(_ list: ReviewList) {
        let category = list.category
        if list.isFirst {
            removeReviewList(with: category)
        }
        
        if let findIndex = reviewLists.firstIndex(where: { $0.category == category }) {
            reviewLists[findIndex].update(for: list)
            delegate?.reviewListModel(self, didSuccess: reviewLists[findIndex])
        } else {
            reviewLists.append(list)
            delegate?.reviewListModel(self, didSuccess: list)
        }
    }
}

// MARK: - Networking
extension ReviewListModel {
    func loadReviews(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        var offset: Int = 0
        var size: Int = config.defaultSize
        
        if let list = reviewList(with: category) {
            if list.isLast {
                self.delegate?.reviewListDidLast(self)
                return
            }
            offset = list.currentPage + 1
            size = list.size
        }
        
        if category == .all {
            getAllReview(with: filter, offset: offset, size: size)
        } else {
            getReview(with: category, filter: filter, offset: offset, size: size)
        }
    }
    
    func reloadReviews(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        let offset: Int = 0
        let size: Int = config.defaultSize
        
        if category == .all {
            getAllReview(with: filter, offset: offset, size: size)
        } else {
            getReview(with: category, filter: filter, offset: offset, size: size)
        }
    }
    
    private func getReview(with category: Category, filter: Sort, offset: Int, size: Int) {
        isLoading = true
        let request = GetReviewRequest(category: category.apiKey, filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.getReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 검색 성공
                var list = succeed
                list.category = category
                list.sortOption = filter
                self.saveReviewList(list)
            } else {
                // 오류 발생
                if failed?.isReviewError ?? false {
                    self.delegate?.reviewListDidFail(self)
                    return
                }
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    private func getAllReview(with filter: Sort, offset: Int, size: Int) {
        isLoading = true
        let request = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 검색 성공
                var list = succeed
                list.category = .all
                list.sortOption = filter
                self.saveReviewList(list)
            } else {
                // 오류 발생
                if failed?.isReviewError ?? false {
                    self.delegate?.reviewListDidFail(self)
                    return
                }
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    func syncReviewList(with category: Category, review: Review) {
        guard !isLoading else { return }
            if category == .all {
                syncGetAllReview(with: review)
            } else {
                syncGetReview(with: category, review: review)
            }
    }
    
    private func syncGetReview(with category: Category, review: Review) {
        isLoading = true
        guard let listIndex = reviewListIndex(with: category) else { return }
        let list = reviewLists[listIndex]
        
        guard let reviewIndex = list.reviews.firstIndex(where: { $0.id == review.id }) else { return }
        let filter = list.sortOption
        let offset = reviewIndex / config.defaultSize
        let size = list.size
        
        let request = GetReviewRequest(category: category.apiKey, filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.getReview(request: request) { [weak self] succeed, _ in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 현재 페이지 데이터 갱신
                let startIndex = offset * size
                self.reviewLists[listIndex].updateSync(for: succeed, startIndex: startIndex)
                self.delegate?.reviewListModel(self, didAync: self.reviewLists[listIndex])
            } else {
                // 오류 발생
            }
        }
    }
    
    private func syncGetAllReview(with review: Review) {
        isLoading = true
        guard let listIndex = reviewListIndex(with: .all) else { return }
        let list = reviewLists[listIndex]
        
        guard let reviewIndex = list.reviews.firstIndex(where: { $0.id == review.id }) else { return }
        let filter = list.sortOption
        let offset = reviewIndex / config.defaultSize
        let size = list.size
        
        let allRequest = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: allRequest) { [weak self]  succeed, _ in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 현재 페이지 데이터 갱신
                let startIndex = offset * config.defaultSize
                self.reviewLists[listIndex].updateSync(for: succeed, startIndex: startIndex)
                self.delegate?.reviewListModel(self, didAync: self.reviewLists[listIndex])
            } else {
                // 오류 발생
            }
        }
    }
        
    func deleteReview(for review: Review) {
        guard let id = review.id else { return }
        
        let request = DeleteReviewRequest(boardId: id)
        provider.reviewService.deleteReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                if succeed {
                    self.delegate?.reviewListModel(self, didDelete: review)
                } else {
                    self.delegate?.reviewListDidFailDeleteReview(self)
                }
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
}
