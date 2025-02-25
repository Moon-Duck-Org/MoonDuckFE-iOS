//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 2/17/25.
//

import Foundation
import UIKit
import RealmSwift

protocol ReviewModelDelegate: AnyObject {
    func getReviews(_ model: ReviewModelType, didSuccess reviews: [Review])
    func getReview(_ model: ReviewModelType, didSuccess review: Review)
    func deleteReview(_ model: ReviewModelType, didSuccess review: Review)
    func writeReview(_ model: ReviewModelType, didSuccess review: Review)
    func editReview(_ model: ReviewModelType, didSuccess review: Review)
    
    func didFailToGetReviews(_ model: ReviewModelType)
    func didFailToGetReview(_ model: ReviewModelType)
    func didFailToDeleteReview(_ model: ReviewModelType)
    func didFailToWriteReview(_ model: ReviewModelType)
    func didFailToEditReview(_ model: ReviewModelType)
}
extension ReviewModelDelegate {
    func getReviews(_ model: ReviewModelType, didSuccess reviews: [Review]) { }
    func getReview(_ model: ReviewModelType, didSuccess review: Review) { }
    func deleteReview(_ model: ReviewModelType, didSuccess review: Review) { }
    func writeReview(_ model: ReviewModelType, didSuccess review: Review) { }
    func editReview(_ model: ReviewModelType, didSuccess review: Review) { }
    
    func didFailToGetReviews(_ model: ReviewModelType) { }
    func didFailToGetReview(_ model: ReviewModelType) { }
    func didFailToDeleteReview(_ model: ReviewModelType) { }
    func didFailToWriteReview(_ model: ReviewModelType) { }
    func didFailToEditReview(_ model: ReviewModelType) { }
}

protocol ReviewModelType: AnyObject {
    // Data
    var delegate: ReviewModelDelegate? { get set }
    
    var reviews: [Review] { get }
    
    func numberOfReviews(with category: Category) -> Int
    func review(at index: Int) -> Review?
    func countReviews() -> [Category: Int]
    
    // DateBase
    func loadReviews(with category: Category, sort: Sort)
    func getReview(_ id: ObjectId)
    func deleteReview(for review: Review)
    func writeReview(for review: Review, with images: [UIImage])
    func editReview(for review: Review, with images: [UIImage])
}

class ReviewModel: ReviewModelType {
    
    private let provider: AppStorages
    
    init(_ provider: AppStorages) {
        self.provider = provider
    }
    
    private var isLoading: Bool = false
    var reviews: [Review] = []
    
    // MARK: - Data
    weak var delegate: ReviewModelDelegate?
    
    func numberOfReviews(with category: Category) -> Int {
        if category == .all {
            return provider.reviewStorage.count()
        } else {
            return provider.reviewStorage.count(with: category)
        }
    }
    
    func review(at index: Int) -> Review? {
        if index < reviews.count {
            return reviews[index]
        }
        return nil
    }
    
    func countReviews() -> [Category: Int] {
        return provider.reviewStorage.countReviews()
    }
    
    // MARK: - Logic
    
    // MARK: - DataBase
    func loadReviews(with category: Category, sort: Sort) {
        var realms: [RealmReview] = []
        if category == .all {
            realms = provider.reviewStorage.getAllReviews(sort: sort)
        } else {
            realms = provider.reviewStorage.getReviews(with: category, sort: sort)
        }
        reviews = realms.map { $0.toDomain() }
        delegate?.getReviews(self, didSuccess: reviews)
    }
    
    func getReview(_ id: ObjectId) {
        if let realm = provider.reviewStorage.getReview(for: id) {
            delegate?.getReview(self, didSuccess: realm.toDomain())
        } else {
            delegate?.didFailToGetReview(self)
        }
    }
    
    func deleteReview(for review: Review) {
        guard let id = review.id else { return }
        
        provider.reviewStorage.deleteReview(for: id) { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.reviews.removeAll { $0.id == review.id }
                self.delegate?.deleteReview(self, didSuccess: review)
            } else {
                self.delegate?.didFailToDeleteReview(self)
            }
        }
    }
    
    // 리뷰 작성
    func writeReview(for review: Review, with images: [UIImage]) {
        // 1. Realm Review 생성
        let realmReview = createRealmReview(from: review)
        // 2. Realm Review 추가
        provider.reviewStorage.add(realmReview)

        guard !images.isEmpty else {
            // 3. image가 없을 경우, delegate 호출
            delegate?.writeReview(self, didSuccess: review)
            return
        }

        // 3. image가 있을 경우, 생성된 id로 FileManager Image 저장 -> Path Return
        ImageManager.shared.saveImages(images: images, reviewID: realmReview.id.stringValue) { [weak self] paths in
            // 4. Realm에 Image 정보 Update
            self?.updateReviewImages(with: realmReview, paths: paths, review: review)
        }
    }
    
    // 리뷰 수정
    func editReview(for review: Review, with images: [UIImage]) {
        guard let id = review.id else { return }
        
        // 1. Realm Review 생성
        let realmReview = createRealmReview(from: review)
        // 2. 수정 될 Review Id 저장 + 수정 날짜 업데이트
        realmReview.id = id
        realmReview.modifiedAt = Date()

        guard !images.isEmpty else {
            // 3. image가 없을 경우, image 데이터 삭제
            self.editReview(with: realmReview, paths: [], review: review)
            return
        }
        
        // 3. image가 있을 경우, 수정할 id로 FileManager Image 저장 -> Path Return
        ImageManager.shared.saveImages(images: images, reviewID: id.stringValue) { [weak self] paths in
            self?.editReview(with: realmReview, paths: paths, review: review)
        }
    }
    
    private func editReview(with realmReview: RealmReview, paths: [String], review: Review) {
        // 1. Image Path Update
        applyImagePaths(to: realmReview, with: paths)
        // 2. Realm Update
        provider.reviewStorage.update(for: realmReview) { [weak self] isSuccess in
            guard let self else { return }
            // 3. Delegate 호출
            if isSuccess {
                delegate?.editReview(self, didSuccess: review)
            } else {
                delegate?.didFailToEditReview(self)
            }
        }
    }
    
    private func createRealmReview(from review: Review) -> RealmReview {
        let realmReview = RealmReview()
        realmReview.rating = review.rating
        realmReview.categoryKey = review.category.apiKey
        realmReview.programTitle = review.program.title
        realmReview.programSubTitle = review.program.subInfo
        realmReview.title = review.title
        realmReview.link = review.link ?? ""
        realmReview.content = review.content
        return realmReview
    }
    
    private func updateReviewImages(with realmReview: RealmReview, paths: [String], review: Review) {
        Log.info("✅ 저장된 이미지 경로: \(paths)")
        provider.reviewStorage.updateImages(for: realmReview, with: paths) { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                delegate?.writeReview(self, didSuccess: review)
            } else {
                delegate?.didFailToWriteReview(self)
            }
        }
    }
    
    private func applyImagePaths(to realmReview: RealmReview, with paths: [String]) {
        let imageKeys = [\RealmReview.image1, \.image2, \.image3, \.image4, \.image5]
        
        for (index, keyPath) in imageKeys.enumerated() {
            realmReview[keyPath: keyPath] = paths.indices.contains(index) ? paths[index] : ""
        }
    }

}
