//
//  WriteReviewViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import Foundation

protocol WriteReviewPresenter: AnyObject {
    var view: WriteReviewView? { get set }
    
    // Data
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func tapSaveButton()
    func tapRatingButton(at tag: Int)
    
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
    
    private struct Config {
        let maxTitleCount = 40
        let maxContentCount = 500
    }
    private let config: Config = Config()
    
    private var program: Program? {
        didSet {
            if let program {
                view?.updateCategory(program.category)
                view?.updateProgramInfo(title: program.title, subTitle: program.getSubInfo())
            }
        }
    }
    private var titleText: String?
    private var contentText: String?
    private var rating: Int = 0 {
        didSet {
            view?.updateRating(rating)
        }
    }
    private var linkText: String?
    
    init(with provider: AppServices, program: Program) {
        self.program = program
        super.init(with: provider)
    }

}

extension WriteReviewViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.createTouchEvent()
    }
    
    // MARK: - Action
    func tapSaveButton() {
        if let program {
            
        } else {
            view?.showToast("카테고리를 선택해주세요.")
            return
        }
        
        if let titleText, titleText.isNotEmpty {
           
        } else {
            view?.showToast("제목을 입력해주세요.")
            return
        }
        
        if let contentText, contentText.isNotEmpty {
           
        } else {
            view?.showToast("내용을 입력해주세요.")
            return
        }
        
        if rating > 0 {
            
        } else {
            view?.showToast("별점을 입력해주세요.")
            return
        }
        
        // TODO: 기록 작성 API 연결
        view?.backToHome()
    }
    
    func tapRatingButton(at tag: Int) {
        guard rating != tag else { return }
        rating = tag
    }
    
    // MARK: - Logic
    
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewPresenter {
    func titleTextFieldEditingChanged(_ text: String?) {
        view?.updateTitleCountLabel("\(text?.count ?? 0)/\(config.maxTitleCount)")
        titleText = text
    }
    
    func linkTextFieldEditingChanged(_ text: String?) {
        guard let text else { return }
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
