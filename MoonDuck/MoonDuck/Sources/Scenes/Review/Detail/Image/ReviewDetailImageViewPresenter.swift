//
//  ReviewDetailImageViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 7/8/24.
//

import Foundation

protocol ReviewDetailImagePresenter: AnyObject {
    var view: ReviewDetailImageView? { get set }
    
    // Data
    var numberOfImages: Int { get }
    var currentPage: Int { get }
    
    func imageUrl(at index: Int) -> String?
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func scrollViewDidEndDecelerating(_ currentPage: Int)
}

class ReviewDetailImageViewPresenter: BaseViewPresenter, ReviewDetailImagePresenter {
    
    weak var view: ReviewDetailImageView?
    
    init(with provider: AppServices,
         imageUrls: [String],
         currentIndex: Int) {
        self.imageUrls = imageUrls
        self.currentPage = currentIndex
        super.init(with: provider, model: AppModels())
    }
    
    // MARK: - Data
    var imageUrls: [String]
    
    var numberOfImages: Int {
        return imageUrls.count
    }
    var currentPage: Int
    
    func imageUrl(at index: Int) -> String? {
        if index < imageUrls.count {
            return imageUrls[index]
        }
        return nil
    }
}

extension ReviewDetailImageViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        updateImageCount(for: currentPage)
        view?.scrollToPage(currentPage)
    }
    // MARK: - Action
    // MARK: - Logic
    private func updateImageCount(for count: Int) {
        let countText = "\(count + 1)/\(imageUrls.count)"
        view?.updateImageCountLabelText(countText)
    }
}
 
// MARK: - UICollectionViewDelegate
extension ReviewDetailImageViewPresenter {
    func scrollViewDidEndDecelerating(_ currentPage: Int) {
        self.currentPage = currentPage
        updateImageCount(for: currentPage)
    }
}
