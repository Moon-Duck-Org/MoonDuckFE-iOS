//
//  WriteReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

// MARK: - API Version

import Foundation
import UIKit

protocol APIWriteReviewModelDelegate: BaseModelDelegate {
    func writeReviewModel(_ model: APIWriteReviewModelType, didSuccess review: APIReview)
}
protocol APIWriteReviewModelType: BaseModelType {
    // Data
    var delegate: APIWriteReviewModelDelegate? { get set }
    var program: Program? { get }
    var review: APIReview? { get }
    var isNewWrite: Bool { get }
    
    // Logic
    
    // Networking
    func putReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?)
    func postReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?)
}

class WriteReviewModel: APIWriteReviewModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices,
         review: APIReview? = nil,
         program: Program? = nil) {
        self.provider = provider
        self.review = review
        self.program = program
    }
    
    // MARK: - Data
    weak var delegate: APIWriteReviewModelDelegate?
    var review: APIReview?
    var program: Program?
    
    // MARK: - Logic
    var isNewWrite: Bool {
        return review == nil
    }
    
    // MARK: - Networking
    func putReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?) {
        guard let review else {
            self.delegate?.error(didRecieve: .unknown)
            return
        }
        
        let programRequest = ProgramRequest(program: review.program)
        let request = WriteReviewRequest(title: title, category: review.category.apiKey, program: programRequest, content: content, url: url ?? "", score: score, boardId: review.id)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.provider.reviewService.putReview(request: request, images: images) { [weak self] succeed, failed in
                guard let self else { return }
                if let succeed {
                    AnalyticsService.shared.logEvent(
                        .SUCCESS_EDIT_REIVEW,
                        parameters: [.REVIEW_ID: review.id ?? -1,
                                     .CATEGORY_TYPE: review.program.category.rawValue,
                                     .PROGRAM_NAME: review.program.title,
                                     .IS_REVIEW_LINK: url?.isNotEmpty ?? false,
                                     .REVIEW_IMAGE_COUNT: images?.count ?? 0]
                    )
                    
                    self.delegate?.writeReviewModel(self, didSuccess: succeed)
                } else {
                    // 오류 발생
                    AnalyticsService.shared.logEvent(
                        .FAIL_WRITE_REVIEW,
                        parameters: [.REVIEW_ID: review.id ?? -1,
                                     .IS_REVIEW_LINK: url?.isNotEmpty ?? false,
                                     .REVIEW_IMAGE_COUNT: images?.count ?? 0,
                                     .ERROR_CODE: failed?.code ?? "",
                                     .ERROR_MESSAGE: failed?.message ?? "",
                                     .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                    )
                    
                    self.delegate?.error(didRecieve: failed)
                }
            }
        }
    }
    
    func postReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?) {
        guard let program else { 
            self.delegate?.error(didRecieve: .unknown)
            return
        }
        
        let programRequest = ProgramRequest(program: program)
        let request = WriteReviewRequest(title: title, category: program.category.apiKey, program: programRequest, content: content, url: url ?? "", score: score)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.provider.reviewService.postReview(request: request, images: images) { [weak self] succeed, failed in
                guard let self else { return }
                if let succeed {
                    AnalyticsService.shared.logEvent(
                        .SUCCESS_WRITE_REIVEW,
                        parameters: [.CATEGORY_TYPE: program.category.rawValue,
                                     .PROGRAM_NAME: program.title,
                                     .IS_REVIEW_LINK: url?.isNotEmpty ?? false,
                                     .REVIEW_IMAGE_COUNT: images?.count ?? 0]
                    )
                    
                    self.delegate?.writeReviewModel(self, didSuccess: succeed)
                } else {
                    // 오류 발생
                    AnalyticsService.shared.logEvent(
                        .FAIL_WRITE_REVIEW,
                        parameters: [.CATEGORY_TYPE: program.category.rawValue,
                                     .PROGRAM_NAME: program.title,
                                     .IS_REVIEW_LINK: url?.isNotEmpty ?? false,
                                     .REVIEW_IMAGE_COUNT: images?.count ?? 0,
                                     .ERROR_CODE: failed?.code ?? "",
                                     .ERROR_MESSAGE: failed?.message ?? "",
                                     .TIME_STAMP: Utils.getCurrentKSTTimestamp()]
                    )
                    
                    self.delegate?.error(didRecieve: failed)
                }
            }
        }
    }
}
