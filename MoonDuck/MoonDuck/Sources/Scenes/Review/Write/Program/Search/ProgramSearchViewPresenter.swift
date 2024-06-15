//
//  ProgramSearchViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import Foundation

protocol ProgramSearchPresenter: AnyObject {
    var view: ProgramSearchView? { get set }
    
    /// Data
    var numberOfPrograms: Int { get }
    
    func program(at index: Int) -> ReviewProgramMovie?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action  
    
    /// TextField Delegate
    func textFieldShouldReturn(_ text: String?) -> Bool
    func textFieldDidEndEditing(_ text: String?)
    func textFieldShouldBeginEditing(_ text: String?) -> Bool
    func scrollViewWillBeginDragging()
}

class ProgramSearchViewPresenter: Presenter, ProgramSearchPresenter {
    weak var view: ProgramSearchView?
    
    let category: ReviewCategory
    let model: ProgramSearchModelType
        
    init(with provider: AppServices, category: ReviewCategory) {
        self.category = category
        self.model = ProgramSearchModel(provider)
        super.init(with: provider)
        self.model.delegate = self
    }
    
    // MARK: - Data
    var numberOfPrograms: Int {
        return model.numberOfPrograms
    }
    
    func program(at index: Int) -> ReviewProgramMovie? {
        if index < model.numberOfPrograms {
            return model.programs[index]
        } else {
            return nil
        }
    }
}

extension ProgramSearchViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.createTouchEvent()
    }
    
    // MARK: - Action
    
}

// MARK: - UITextFieldDelegate
extension ProgramSearchViewPresenter {
    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text else { return true }
        model.searchMovie(text)
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
    func scrollViewWillBeginDragging() {
        view?.endEditing()
    }
}

// MARK: - ProgramSearchModelDelegate
extension ProgramSearchViewPresenter: ProgramSearchModelDelegate {
    func programSearchModel(_ searchModel: ProgramSearchModel, didChange movieList: [ReviewProgramMovie]) {
        view?.reloadTableView()
    }
    
    func programSearchModel(_ searchModel: ProgramSearchModel, didRecieve error: Error?) {
        // TODO: 오류 처리
    }
}
