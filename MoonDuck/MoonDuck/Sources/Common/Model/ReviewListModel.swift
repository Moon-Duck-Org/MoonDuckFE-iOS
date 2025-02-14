//
//  ReviewListModel.swift
//  MoonDuck
//
//  Created by suni on 2/15/25.
//

import Foundation

protocol ReviewListModelDelegate: AnyObject {
    
}

protocol ReviewListModelType: AnyObject {
    
}

class ReviewListModel: ReviewListModelType {
    private let provider: AppStorages
    private var isLoading: Bool = false
    private var reviewLists: [ReviewList] = []
    
    init(_ provider: AppStorages) {
        self.provider = provider
    }
}
