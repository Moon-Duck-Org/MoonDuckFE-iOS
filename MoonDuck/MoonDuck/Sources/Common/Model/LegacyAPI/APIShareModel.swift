//
//  ShareModel.swift
//  MoonDuck
//
//  Created by suni on 7/15/24.
//

// MARK: - API Version

import Foundation

protocol APIShareModelDelegate: AnyObject {
    func shareModel(_ model: APIShareModelType, didSuccess url: String)
    func shareModel(_ model: APIShareModelType, didRecieve error: APIError?)
}

protocol APIShareModelType: AnyObject {
    // Data
    var delegate: APIShareModelDelegate? { get set }
    
    // Logic
    
    // Networking
    func getShareUrl(with reviewId: Int)
}

class APIShareModel: APIShareModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: APIShareModelDelegate?
        
    // MARK: - Logic
    
}

// MARK: - Networking
extension APIShareModel {
    func getShareUrl(with reviewId: Int) {
        let request = GetShareUrlRequest(boardId: reviewId)
        provider.shareService.getShareUrl(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.delegate?.shareModel(self, didSuccess: succeed)
            } else {
                // 오류 발생
                self.delegate?.shareModel(self, didRecieve: failed)
            }
        }
    }
}
