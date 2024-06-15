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
    
    /// Action
    
    /// TextField Delegate
    func textFieldShouldReturn(_ text: String?) -> Bool
    func textFieldDidEndEditing(_ text: String?)
    func textFieldShouldBeginEditing(_ text: String?) -> Bool
}

class WriteReviewViewPresenter: Presenter, WriteReviewPresenter {
    
    weak var view: WriteReviewView?
}

extension WriteReviewViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.createTouchEvent()
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
