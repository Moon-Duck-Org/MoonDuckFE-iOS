//
//  WriteReviewViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import Foundation
import UIKit

protocol WriteReviewPresenterDelegate: AnyObject {
    func writeReview(_ presenter: WriteReviewPresenter, didSuccess review: Review, isNewWrite: Bool)
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
    func cancelButtonTapped()
    func saveButtonTapped()
    func ratingButtonTapped(at tag: Int)
    func selectImages(_ images: [UIImage])
    func exceededImagesCount(_ count: Int)
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
    
    // UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin() -> Bool
}

class WriteReviewViewPresenter: BaseViewPresenter, WriteReviewPresenter {
    
    weak var view: WriteReviewView?
    
    private weak var delegate: WriteReviewPresenterDelegate?
    
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
            view?.updateRating(for: rating)
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
         model: AppModels,
         delegate: WriteReviewPresenterDelegate?) {
        self.delegate = delegate
        super.init(with: provider, model: model)
        self.model.writeReviewModel?.delegate = self
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
        if let review = model.writeReviewModel?.review {
            let program = review.program
            
            AnalyticsService.shared.logEvent(.VIEW_EDIT_REIVEW, parameters: [.CATEGORY_TYPE: program.category.rawValue])
            
            view?.updateProgramInfo(for: program.category, with: program.title, and: program.subInfo)
            view?.updateTextField(for: review.title, with: review.content, and: review.link)
            titleText = review.title
            contentText = review.content
            linkText = review.link
            view?.updateTitleCountLabelText(with: "\(review.title.count)/\(config.maxTitleCount)")
            view?.updateContentCountLabelText(with: "\(review.content.count)/\(config.maxContentCount)")
            view?.updateRating(for: review.rating)
            rating = review.rating
            
            for imageUrl in review.imageUrlList {
                if let url = URL(string: imageUrl) {
                    Utils.downloadImage(from: url) { [weak self] image in
                        self?.images.append(image)
                    }
                }
            }
        } else if let program = model.writeReviewModel?.program {
            AnalyticsService.shared.logEvent(.VIEW_WRITE_REVIEW, parameters: [.CATEGORY_TYPE: program.category.rawValue])
            
            view?.updateProgramInfo(for: program.category, with: program.title, and: program.subInfo)
        }
    }
    
    // MARK: - Action
    func cancelButtonTapped() {
        if isWritingReview() {
            view?.showBackAlert()
        } else {
            view?.back()
        }
    }
    
    func saveButtonTapped() {
        view?.updateLoadingView(isLoading: true)
        var categoryType = ""
        if let category = model.writeReviewModel?.program?.category.rawValue {
            categoryType = category
        } else if let category = model.writeReviewModel?.program?.title {
            categoryType = category
        }
        
        var title: String = ""
        var content: String = ""
        var score: Int = 0
        
        if let titleText, titleText.isNotEmpty {
            title = titleText
        } else {
            if model.writeReviewModel?.isNewWrite ?? false {
                AnalyticsService.shared.logEvent(.TOAST_WRITE_REVIEW_EMPTY_TITLE, parameters: [.CATEGORY_TYPE: categoryType])
            }
            
            view?.updateLoadingView(isLoading: false)
            view?.showToastMessage(L10n.Localizable.Write.emptyTitleMessage)
            return
        }
        
        if let contentText, contentText.isNotEmpty {
            content = contentText
        } else {
            if model.writeReviewModel?.isNewWrite ?? false {
                AnalyticsService.shared.logEvent(.TOAST_WRITE_REVIEW_EMPTY_CONTENT, parameters: [.CATEGORY_TYPE: categoryType])
            }
            
            view?.updateLoadingView(isLoading: false)
            view?.showToastMessage(L10n.Localizable.Write.emptyContentMessage)
            return
        }
        
        if rating > 0 {
            score = rating
        } else {
            if model.writeReviewModel?.isNewWrite ?? false {
                AnalyticsService.shared.logEvent(.TOAST_WRITE_REVIEW_EMPTY_RATING, parameters: [.CATEGORY_TYPE: categoryType])
            }
            
            view?.updateLoadingView(isLoading: false)
            view?.showToastMessage(L10n.Localizable.Write.emptyRatingMessage)
            return
        }
        
        if model.writeReviewModel?.isNewWrite ?? false {
            AnalyticsService.shared.logEvent(
                .TAP_WRITE_REIVEW_COMPLETE,
                parameters: [.CATEGORY_TYPE: categoryType,
                             .PROGRAM_NAME: model.writeReviewModel?.program?.title ?? "",
                             .IS_REVIEW_LINK: linkText?.isNotEmpty ?? false,
                             .REVIEW_IMAGE_COUNT: images.count]
            )
            
            model.writeReviewModel?.postReview(title: title, content: content, score: score, url: linkText, images: images)
        } else {
            AnalyticsService.shared.logEvent(
                .TAP_EDIT_REIVEW_COMPLETE,
                parameters: [.REVIEW_ID: model.writeReviewModel?.review?.id ?? -1,
                             .CATEGORY_TYPE: categoryType,
                             .PROGRAM_NAME: model.writeReviewModel?.review?.program.title ?? "",
                             .IS_REVIEW_LINK: linkText?.isNotEmpty ?? false,
                             .REVIEW_IMAGE_COUNT: images.count]
            )
            
            model.writeReviewModel?.putReview(title: title, content: content, score: score, url: linkText, images: images)
        }
    }
    
    func ratingButtonTapped(at tag: Int) {
        guard rating != tag else { return }
        rating = tag
    }
    
    func selectImages(_ images: [UIImage]) {
        self.images.append(contentsOf: images)
    }
    
    func exceededImagesCount(_ count: Int) {
        if count > 0 {
            view?.showErrorAlert(title: "", message: L10n.Localizable.Error.systemImageSizeMessage("\(count)"))
        }
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
    
    private func isWritingReview() -> Bool {
        if titleText?.isNotEmpty ?? false ||
            contentText?.isNotEmpty ?? false ||
            linkText?.isNotEmpty ?? false ||
            images.count > 0 {
            return true
        } else {
            return false
        }
    }
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewPresenter {
    func titleTextFieldEditingChanged(_ text: String?) {
        guard let text else { return }
        
        var currentText = text
        if text.count > config.maxTitleCount {
            let maxIndex = text.index(text.startIndex, offsetBy: config.maxTitleCount)
            let replaceText = String(text[..<maxIndex])
            view?.updateTitleTextFieldText(with: replaceText)
            currentText = replaceText
        }
        view?.updateTitleCountLabelText(with: "\(currentText.count)/\(config.maxTitleCount)")
        titleText = currentText
    }
    
    func linkTextFieldEditingChanged(_ text: String?) {
        guard let text else { return }
        linkText = text
    }
    
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String, isTitle: Bool) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ text: String?, isTitle: Bool) {
        view?.isEditingText = true
    }
}

// MARK: - UITextViewDelegate
extension WriteReviewViewPresenter {
    func textViewDidChange(_ text: String?) {
        guard let text else { return }
        
        var currentText = text
        if text.count > config.maxContentCount {
            let maxIndex = text.index(text.startIndex, offsetBy: config.maxContentCount)
            let replaceText = String(text[..<maxIndex])
            view?.updateContentTextViewText(with: replaceText)
            currentText = replaceText
        }
        
        view?.updateContentCountLabelText(with: "\(currentText.count)/\(config.maxContentCount)")
        contentText = currentText
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

// MARK: - UIGestureRecognizerDelegate
extension WriteReviewViewPresenter {
    func gestureRecognizerShouldBegin() -> Bool {
        if isWritingReview() {
            view?.showBackAlert()
            return false
        } else {
            return true
        }
    }
}

// MARK: - WriteReviewModelDelegate
extension WriteReviewViewPresenter: WriteReviewModelDelegate {
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        
        guard let error else { return }
        
        if error.isAuthError {
            AuthManager.shared.logout()
            let appModel = AppModels(
                userModel: UserModel(provider)
            )
            let presenter = LoginViewPresenter(with: provider, model: appModel)
            view?.showAuthErrorAlert(with: presenter)
            return
        } else if error.isNetworkError {
            view?.showNetworkErrorAlert()
            return
        } else if error.isSystemError {
            view?.showSystemErrorAlert()
            return
        } else if error.imageSizeLimitExceeded {
            view?.showErrorAlert(title: "", message: L10n.Localizable.Error.networkImageSizeMessage)
            return
        } else {
            view?.showErrorAlert(title: L10n.Localizable.Error.title("기록 작성"), message: L10n.Localizable.Error.message)
        }
    }
    
    func writeReviewModel(_ model: WriteReviewModelType, didSuccess review: Review) {
        view?.updateLoadingView(isLoading: false)
        
        delegate?.writeReview(self, didSuccess: review, isNewWrite: model.isNewWrite)
    }
}
