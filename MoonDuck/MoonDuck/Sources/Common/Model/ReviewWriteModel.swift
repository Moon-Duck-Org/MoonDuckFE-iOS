//
//  ReviewWriteModel.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import Foundation

protocol ReviewWriteModelDelegate: AnyObject {
    func reviewWriteModel(_ model: ReviewWriteModel, didSuccess isSuccess: Bool)
    
}
protocol ReviewWriteModelType: AnyObject {
    
}

class ReviewWriteModel: ReviewWriteModelType {
    
}
