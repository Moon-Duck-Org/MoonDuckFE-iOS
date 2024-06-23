//
//  WriteReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

import Foundation
import UIKit

protocol WriteReviewModelDelegate: AnyObject {
    func writeReview(_ model: WriteReviewModel, didSuccess review: Review)
    func writeReview(_ model: WriteReviewModel, didRecieve error: APIError?)
    
}
protocol WriteReviewModelType: AnyObject {
    // Data
    var delegate: WriteReviewModelDelegate? { get set }
    var program: Program { get }
    
    // Logic
    
    // Networking
    func writeReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?)
}

class WriteReviewModel: WriteReviewModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices, program: Program) {
        self.provider = provider
        self.program = program
    }
    
    // MARK: - Data
    weak var delegate: WriteReviewModelDelegate?
    var program: Program
    
    // MARK: - Logic
    
    // MARK: - Networking
    func writeReview(title: String, content: String, score: Int, url: String?, images: [UIImage]?) {
        let programRequest = ProgramRequest(program: program)
        let request = PostReviewRequest(title: title, category: program.category.apiKey, program: programRequest, content: content, url: url ?? "", score: score)
        
        provider.reviewService.postReview(request: request, images: images) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                self.delegate?.writeReview(self, didSuccess: succeed)
            } else {
                // 오류 발생
                if let code = failed {
                    if code.isReviewError {
                        self.delegate?.writeReview(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.writeReview(title: title, content: content, score: score, url: url, images: images)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.writeReview(self, didRecieve: failed)
                            }
                        }
                        return
                    }
                }
                Log.error(APIError.unowned)
                self.delegate?.writeReview(self, didRecieve: failed)
            }
        }
    }
}
