//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 2/17/25.
//

import Foundation

protocol ReviewModelDelegate: AnyObject {
    func getReviews(_ model: ReviewModelType, didSuccess reviews: [RealmReview])
    func deleteReview(_ model: ReviewModelType, didSuccess review: RealmReview)
    func writeReview(_ model: ReviewModelType, didSuccess review: RealmReview)
    func editReview(_ model: ReviewModelType, didSuccess review: RealmReview)
    
    func didFailToGetReviews(_ model: ReviewModelType)
    func didFailToDeleteReview(_ model: ReviewModelType)
    func didFailToWriteReview(_ model: ReviewModelType)
    func didFailToEditReview(_ model: ReviewModelType)
}
extension ReviewModelDelegate {
    func getReviews(_ model: ReviewModelType, didSuccess reviews: [RealmReview]) { }
    func deleteReview(_ model: ReviewModelType, didSuccess review: RealmReview) { }
    func writeReview(_ model: ReviewModelType, didSuccess review: RealmReview) { }
    func editReview(_ model: ReviewModelType, didSuccess review: RealmReview) { }
    
    func didFailToGetReviews(_ model: ReviewModelType) { }
    func didFailToDeleteReview(_ model: ReviewModelType) { }
    func didFailToWriteReview(_ model: ReviewModelType) { }
    func didFailToEditReview(_ model: ReviewModelType) { }
}

protocol ReviewModelType: AnyObject {
    // Data
    var delegate: ReviewModelDelegate? { get set }
    
    func numberOfReviews(with category: Category) -> Int
//    func review(with category: Category, at index: Int) -> Review?
//    func reviews(with category: Category) -> [Review]?
    
    // DateBase
    func loadReviews(with category: Category, sort: Sort)
    func deleteReview(for review: RealmReview)
    func writeReview(for review: RealmReview)
    func editReview(for review: RealmReview)
}

class ReviewModel: ReviewModelType {
    
    private let provider: AppStorages
    
    init(_ provider: AppStorages) {
        self.provider = provider
    }
    
    private var isLoading: Bool = false
    private var reviews: [RealmReview] = []
    
    // MARK: - Data
    weak var delegate: ReviewModelDelegate?
    
    func numberOfReviews(with category: Category) -> Int {
        if category == .all {
            return provider.reviewStorage.count()
        } else {
            return provider.reviewStorage.count(with: category)
        }
    }
    
    // MARK: - Logic
    

    // MARK: - DataBase
    func loadReviews(with category: Category, sort: Sort) {
        if category == .all {
            reviews = provider.reviewStorage.getAllReviews(sort: sort)
        } else {
            reviews = provider.reviewStorage.getReviews(with: category, sort: sort)
        }
        delegate?.getReviews(self, didSuccess: reviews)
    }
    
    func deleteReview(for review: RealmReview) {
        provider.reviewStorage.deleteReview(for: review.id) { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.reviews.removeAll { $0.id == review.id }
                self.delegate?.deleteReview(self, didSuccess: review)
            } else {
                self.delegate?.didFailToDeleteReview(self)
            }
        }
    }
    
    func writeReview(for review: RealmReview) {
        provider.reviewStorage.add(review)
        delegate?.writeReview(self, didSuccess: review)
    }
    
    // TODO: 리뷰 수정
    func editReview(for review: RealmReview) {
        provider.reviewStorage.add(review)
        delegate?.writeReview(self, didSuccess: review)
    }
    
}
