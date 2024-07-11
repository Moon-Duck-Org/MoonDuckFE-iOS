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
    
    func program(at index: Int) -> Program?
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func userInputButtonTapped()
    func selectProgram(at index: Int)
    func searchNextProgram()
    
    // TextField Delegate
    func searchTextFieldEditingChanged(_ text: String?)
    func textFieldDidBeginEditing(_ text: String?)
    func textFieldShouldReturn(_ text: String?) -> Bool
    
    // TableView Delegate
    func scrollViewWillBeginDragging()
}

class ProgramSearchViewPresenter: BaseViewPresenter, ProgramSearchPresenter {
    weak var view: ProgramSearchView?
    
    private let model: ProgramSearchModelType
    private var delegate: WriteReviewPresenterDelegate?
    
    private var searchText: String?
    
    init(with provider: AppServices,
         model: ProgramSearchModel,
         delegate: WriteReviewPresenterDelegate?) {
        self.model = model
        self.delegate = delegate
        super.init(with: provider)
        self.model.delegate = self
    }
    
    // MARK: - Data
    var numberOfPrograms: Int {
        return model.numberOfPrograms
    }
    
    func program(at index: Int) -> Program? {
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
        view?.updateUserInputButtonEnabled(false)
        
        view?.updateTextFieldPlaceHolder(with: "\(model.category.title) 검색어 입력")
    }
    
    // MARK: - Action
    func userInputButtonTapped() {
        if let searchText, searchText.isNotEmpty {
            let program = Program(category: model.category, title: searchText)
            moveWriteReview(with: program)
        } else {
            showToastWithEndEditing("\(model.category.title) 제목을 입력해주세요.")
        }
    }
    
    func selectProgram(at index: Int) {
        if let program = program(at: index) {
            moveWriteReview(with: program)
        }
    }
    
    func searchNextProgram() {
        if !model.isLastPrograms {
            view?.updateLoadingView(isLoading: true)
            model.searchNext()
        }
    }
    
    // MARK: Logic
    private func showToastWithEndEditing(_ text: String) {
        view?.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view?.showToastMessage(text)
        }
    }
    
    private func moveWriteReview(with program: Program) {
        let model = WriteReviewModel(provider, program: program)
        let presenter = WriteReviewViewPresenter(with: provider, model: model, delegate: delegate)
        view?.moveWriteReview(with: presenter)
    }
    
}

// MARK: - UITextFieldDelegate
extension ProgramSearchViewPresenter {
    func searchTextFieldEditingChanged(_ text: String?) {
        view?.updateUserInputButtonEnabled(text?.isNotEmpty ?? false)
        searchText = text
    }
    
    func textFieldDidBeginEditing(_ text: String?) {
        view?.isEditingText = true
    }
    
    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text,
              text != model.lastSearchText else { return true }
        view?.endEditing()
        view?.updateLoadingView(isLoading: true)
        model.search(text)
        return true
    }
}

// MARK: UITableViewDelegate
extension ProgramSearchViewPresenter {
    func scrollViewWillBeginDragging() {
        view?.endEditing()
    }
}

// MARK: - ProgramSearchModelDelegate
extension ProgramSearchViewPresenter: ProgramSearchModelDelegate {
    func programSearchModel(_ model: ProgramSearchModelType, didChange programs: [Program]) {
        view?.updateLoadingView(isLoading: false)
        view?.reloadTableView()
        view?.endEditing()
        view?.updateEmptyResultViewHidden(!programs.isEmpty)
    }
    
    func programSearchModel(_ model: ProgramSearchModelType, didRecieve error: Error?) {
        view?.updateLoadingView(isLoading: false)
        showToastWithEndEditing("검색 중 오류가 발생하였습니다.")
    }
    
    func programSearchDidLast(_ model: ProgramSearchModelType) {
        view?.updateLoadingView(isLoading: false)
    }
}
