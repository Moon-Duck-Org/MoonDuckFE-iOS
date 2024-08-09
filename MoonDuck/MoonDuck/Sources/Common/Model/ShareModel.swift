//
//  ShareModel.swift
//  MoonDuck
//
//  Created by suni on 7/15/24.
//

import Foundation

protocol ShareModelDelegate: AnyObject {
    func shareModel(_ model: ShareModelType, didSuccess url: String)
    func shareModel(_ model: ShareModelType, didRecieve error: APIError?)
}

protocol ShareModelType: AnyObject {
    // Data
    var delegate: ShareModelDelegate? { get set }
    
    // Logic
    
    // Networking
    func getShareUrl(with reviewId: Int)
}

class ShareModel: ShareModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: ShareModelDelegate?
        
    // MARK: - Logic
    
}

// MARK: - Networking
extension ShareModel {
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
