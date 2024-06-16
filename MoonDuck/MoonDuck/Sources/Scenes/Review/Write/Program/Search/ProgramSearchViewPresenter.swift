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
    
    func program(at index: Int) -> ReviewProgram?
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action  
    func searchTextFieldEditingChanged(_ text: String?)
    func userInputButtonTap()
    
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
    private var searchText: String? {
        didSet {
            view?.updateUserInputButton(searchText?.isNotEmpty ?? false)
        }
    }
        
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
    
    func program(at index: Int) -> ReviewProgram? {
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
        view?.updateUserInputButton(false)
    }
    
    // MARK: - Action
    func userInputButtonTap() {
        view?.endEditing()
        if let searchText, searchText.isNotEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // TODO: 기록 작성 이동
                self.view?.showToast("기록 작성 이동 예정")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.view?.showToast("제목을 입력하세요.")
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension ProgramSearchViewPresenter {
    func searchTextFieldEditingChanged(_ text: String?) {
        searchText = text
    }
    
    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text else { return true }
        model.search(with: category, title: text)
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
    func programSearchModel(_ searchModel: ProgramSearchModel, didChange programs: [ReviewProgram]) {
        view?.reloadTableView()
        view?.updateEmptyResultView(programs.isEmpty)
    }
    
    func programSearchModel(_ searchModel: ProgramSearchModel, didRecieve error: Error?) {
        // TODO: 오류 처리
    }
}
