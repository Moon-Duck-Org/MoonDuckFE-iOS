//
//  ProgramSearchViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import Foundation

protocol ProgramSearchPresenter: AnyObject {
    var view: ProgramSearchView? { get set }
    
    // Data
    var numberOfPrograms: Int { get }
    
    func program(at index: Int) -> ReviewProgram?
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func userInputButtonTap()
    func selectProgram(at index: Int)
    
    // TextField Delegate
    func searchTextFieldEditingChanged(_ text: String?)
    func textFieldDidBeginEditing(_ text: String?)
    func textFieldShouldReturn(_ text: String?) -> Bool
    
    // TableView Delegate
    func scrollViewWillBeginDragging()
}

class ProgramSearchViewPresenter: Presenter, ProgramSearchPresenter {
    weak var view: ProgramSearchView?
    
    private let category: ReviewCategory
    private let model: ProgramSearchModelType
    private var searchText: String?
    
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
        if let searchText, searchText.isNotEmpty {
            let program = ReviewProgram(programType: category, title: searchText)
            let presenter = WriteReviewViewPresenter(with: provider, category: category, program: program)
            view?.moveWriteReview(with: presenter)
        } else {
            showToastWithEndEditing("제목을 입력하세요.")
        }
    }
    
    func selectProgram(at index: Int) {
        if let program = program(at: index) {
            let presenter = WriteReviewViewPresenter(with: provider, category: category, program: program)
            view?.moveWriteReview(with: presenter)
        }
    }
    
    // MARK: Logic
    private func showToastWithEndEditing(_ text: String) {
        view?.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showToast(text)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension ProgramSearchViewPresenter {
    func searchTextFieldEditingChanged(_ text: String?) {
        view?.updateUserInputButton(text?.isNotEmpty ?? false)
        searchText = text
    }
    
    func textFieldDidBeginEditing(_ text: String?) {
        view?.isEditingText = true
    }
    
    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text,
              text != model.lastSearchText else { return true }
        view?.endEditing()
        view?.updateLoadingView(true)
        model.search(with: category, text: text)
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
        view?.updateLoadingView(false)
        view?.reloadTableView()
        view?.endEditing()
        view?.updateEmptyResultView(programs.isEmpty)
    }
    
    func programSearchModel(_ searchModel: ProgramSearchModel, didRecieve error: Error?) {
        view?.updateLoadingView(false)
        showToastWithEndEditing("검색 중 오류가 발생하였습니다.")
    }
}
