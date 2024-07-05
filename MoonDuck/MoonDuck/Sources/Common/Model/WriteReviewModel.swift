//
//  WriteReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

import Foundation
import UIKit

protocol WriteReviewModelDelegate: AnyObject {
    func writeReviewModel(_ model: WriteReviewModel, didSuccess review: Review)
    func writeReviewModel(_ model: WriteReviewModel, didRecieve error: APIError?)
    
}
protocol WriteReviewModelType: AnyObject {
    // Data
    var delegate: WriteReviewModelDelegate? { get set }
    var program: Program? { get }
    var review: Review? { get }
    var isNewWrite: Bool { get }
    
    // Logic
    
    // Networking
    func putReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?)
    func postReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?)
}

class WriteReviewModel: WriteReviewModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices,
         review: Review? = nil,
         program: Program? = nil) {
        self.provider = provider
        self.review = review
        self.program = program
    }
    
    // MARK: - Data
    weak var delegate: WriteReviewModelDelegate?
    var review: Review?
    var program: Program?
    
    // MARK: - Logic
    var isNewWrite: Bool {
        return review == nil
    }
    
    // MARK: - Networking
    func putReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?) {
        guard let review else {
            self.delegate?.writeReviewModel(self, didRecieve: .unknown)
            return
        }
        
        let programRequest = ProgramRequest(program: review.program)
        let request = WriteReviewRequest(title: title, category: review.category.apiKey, program: programRequest, content: content, url: url ?? "", score: score, boardId: review.id)
        
        provider.reviewService.putReview(request: request, images: images) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                self.delegate?.writeReviewModel(self, didSuccess: succeed)
            } else {
                // 오류 발생
                if let code = failed {
                    if code.isReviewError {
                        self.delegate?.writeReviewModel(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.putReview(title: title, content: content, score: score, url: url, images: images)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.writeReviewModel(self, didRecieve: failed)
                            }
                        }
                        return
                    }
                }
                Log.error(APIError.unknown)
                self.delegate?.writeReviewModel(self, didRecieve: failed)
            }
        }
    }
    
    func postReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?) {
        guard let program else { 
            self.delegate?.writeReviewModel(self, didRecieve: .unknown)
            return
        }
        
        let programRequest = ProgramRequest(program: program)
        let request = WriteReviewRequest(title: title, category: program.category.apiKey, program: programRequest, content: content, url: url ?? "", score: score)
        
        provider.reviewService.postReview(request: request, images: images) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                self.delegate?.writeReviewModel(self, didSuccess: succeed)
            } else {
                // 오류 발생
                if let code = failed {
                    if code.isReviewError {
                        self.delegate?.writeReviewModel(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.postReview(title: title, content: content, score: score, url: url, images: images)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.writeReviewModel(self, didRecieve: failed)
                            }
                        }
                        return
                    }
                }
                Log.error(APIError.unknown)
                self.delegate?.writeReviewModel(self, didRecieve: failed)
            }
        }
    }
}
