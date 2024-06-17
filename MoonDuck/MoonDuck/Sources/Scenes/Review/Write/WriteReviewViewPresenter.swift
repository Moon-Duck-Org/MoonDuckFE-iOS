//
//  WriteReviewViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import Foundation

protocol WriteReviewPresenter: AnyObject {
    var view: WriteReviewView? { get set }
    
    /// Data
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    
    /// TextField Delegate
    func textFieldShouldReturn(_ text: String?) -> Bool
    func textFieldDidEndEditing(_ text: String?)
    func textFieldShouldBeginEditing(_ text: String?) -> Bool
}

class WriteReviewViewPresenter: Presenter, WriteReviewPresenter {
    
    weak var view: WriteReviewView?
    private var category: ReviewCategory
    private var program: ReviewProgram
    
    init(with provider: AppServices,
         category: ReviewCategory,
         program: ReviewProgram) {

        self.category = category
        self.program = program
        
        super.init(with: provider)
    }
}

extension WriteReviewViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.createTouchEvent()
        
        view?.updateCategory(category)
        view?.updateProgramInfo(title: program.title, subTitle: program.getSubInfo())
    }
    
    // MARK: - Action
    
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewPresenter {
    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text else { return true }
        
        return true
    }
    
    func textFieldDidEndEditing(_ text: String?) {
        
    }
    
    func textFieldShouldBeginEditing(_ text: String?) -> Bool {
        view?.isEditingText = true
        return true
    }
}

// MARK: UITableViewDataSource
extension ProgramSearchViewPresenter {
    
}
