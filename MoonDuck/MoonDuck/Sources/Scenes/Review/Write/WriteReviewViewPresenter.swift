//
//  WriteReviewViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import Foundation
import PhotosUI
import UIKit

protocol WriteReviewPresenterDelegate: AnyObject {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review)
    func writeReviewDidCancel(_ presenter: WriteReviewPresenter)
}

protocol WriteReviewPresenter: AnyObject {
    var view: WriteReviewView? { get set }
    
    // Data
    var numberOfImagesSelectLimit: Int { get }
    var numberOfImages: Int { get }
    
    func image(at index: Int) -> UIImage
    func deleteImageHandler(at index: Int) -> (() -> Void)?
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func tapSaveButton()
    func tapRatingButton(at tag: Int)
    func selectImages(_ images: [UIImage])
    func selectImage(at index: Int)
    
    // TextField Delegate
    func titleTextFieldEditingChanged(_ text: String?)
    func linkTextFieldEditingChanged(_ text: String?)
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String, isTitle: Bool) -> Bool
    func textFieldDidBeginEditing(_ text: String?, isTitle: Bool)
    
    // TextView Delegate
    func textViewDidChange(_ text: String?)
    func textView(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textViewDidBeginEditing(_ text: String?)
}

class WriteReviewViewPresenter: Presenter, WriteReviewPresenter {
    
    weak var view: WriteReviewView?
    private var model: WriteReviewModelType
    private var delegate: WriteReviewPresenterDelegate?
    
    private struct Config {
        let maxTitleCount = 40
        let maxContentCount = 500
        let maxImageCount = 5
    }
    
    private let config: Config = Config()
    private var titleText: String?
    private var contentText: String?
    private var rating: Int = 0 {
        didSet {
            view?.updateRating(rating)
        }
    }
    private var linkText: String?
    private var images: [UIImage] = [] {
        didSet {
            view?.reloadImages()
        }
    }
    private var addImage: UIImage = Asset.Assets.imageAdd.image
    
    init(with provider: AppServices,
         model: WriteReviewModelType,
         delegate: WriteReviewPresenterDelegate?) {
        self.model = model
        self.delegate = delegate
        super.init(with: provider)
        self.model.delegate = self
    }
    
    // MARK: - Data
    var numberOfImagesSelectLimit: Int {
        return config.maxImageCount - images.count
    }
    
    var numberOfImages: Int {
        if images.count == 0 {
            return 1
        } else if images.count == config.maxImageCount {
            return config.maxImageCount
        } else {
            return images.count + 1
        }
    }
    
    func image(at index: Int) -> UIImage {
        if index < images.count {
            return images[index]
        } else {
            return addImage
        }
    }
    
    func deleteImageHandler(at index: Int) -> (() -> Void)? {
        if index < images.count {
            return { [weak self] in
                self?.deleteImage(at: index)
            }
        }
        return nil
    }

}

extension WriteReviewViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.createTouchEvent()
        
        view?.updateCategory(model.program.category)
        view?.updateProgramInfo(title: model.program.title, subTitle: model.program.subInfo)
    }
    
    // MARK: - Action
    func tapSaveButton() {
        view?.updateLoadingView(true)
        var title: String = ""
        var content: String = ""
        var score: Int = 0
        
        if let titleText, titleText.isNotEmpty {
            title = titleText
        } else {
            view?.updateLoadingView(false)
            view?.showToast("제목을 입력해주세요.")
            return
        }
        
        if let contentText, contentText.isNotEmpty {
            content = contentText
        } else {
            view?.updateLoadingView(false)
            view?.showToast("내용을 입력해주세요.")
            return
        }
        
        if rating > 0 {
            score = rating
        } else {
            view?.updateLoadingView(false)
            view?.showToast("별점을 입력해주세요.")
            return
        }
        
        // TODO: 기록 작성 API 연결
        model.writeReview(title: title, content: content, score: score, url: linkText, images: images)
    }
    
    func tapRatingButton(at tag: Int) {
        guard rating != tag else { return }
        rating = tag
    }
    
    func selectImages(_ images: [UIImage]) {
        self.images.append(contentsOf: images)
    }
    
    func selectImage(at index: Int) {
        if index < images.count {
            // TODO: - 크게 보기 연동?
        } else {
            view?.showSelectImageSheet()
        }
    }
    
    // MARK: - Logic
    private func deleteImage(at index: Int) {
        images.remove(at: index)
    }
    
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewPresenter {
    func titleTextFieldEditingChanged(_ text: String?) {
        view?.updateTitleCountLabel("\(text?.count ?? 0)/\(config.maxTitleCount)")
        titleText = text
    }
    
    func linkTextFieldEditingChanged(_ text: String?) {
        guard let text else { return }
        linkText = text
    }
    
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String, isTitle: Bool) -> Bool {
        let currentText = text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        let maxCount = isTitle ? config.maxTitleCount : config.maxContentCount
        if changeText.count > maxCount {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ text: String?, isTitle: Bool) {
        view?.isEditingText = true
    }
}

// MARK: - UITextViewDelegate
extension WriteReviewViewPresenter {
    func textViewDidChange(_ text: String?) {
        view?.updateContentCountLabel("\(text?.count ?? 0)/\(config.maxContentCount)")
        contentText = text
    }
    
    func textView(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        if changeText.count > config.maxContentCount {
            return false
        } else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ text: String?) {
        view?.isEditingText = true
    }
}

// MARK: - WriteReviewModelDelegate
extension WriteReviewViewPresenter: WriteReviewModelDelegate {
    func writeReview(_ model: WriteReviewModel, didSuccess review: Review) {
        view?.updateLoadingView(false)
        delegate?.writeReview(self, didSuccess: review)
//        view?.backToHome()
    }
    
    func writeReview(_ model: WriteReviewModel, didRecieve error: APIError?) {
        view?.updateLoadingView(false)
        view?.showToast(error?.errorDescription ?? error?.localizedDescription ?? "리뷰 작성 오류 발생")
    }
}
