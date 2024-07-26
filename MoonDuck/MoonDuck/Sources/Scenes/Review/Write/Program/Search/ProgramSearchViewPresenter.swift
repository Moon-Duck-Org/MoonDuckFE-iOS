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
    
    private weak var delegate: WriteReviewPresenterDelegate?
    
    private var searchText: String?
    
    init(with provider: AppServices,
         model: AppModels,
         delegate: WriteReviewPresenterDelegate?) {
        self.delegate = delegate
        super.init(with: provider, model: model)
        self.model.programSearchModel?.delegate = self
    }
    
    // MARK: - Data
    var numberOfPrograms: Int {
        return model.programSearchModel?.numberOfPrograms ?? 0
    }
    
    func program(at index: Int) -> Program? {
        guard let model = model.programSearchModel else { return nil }
        
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
        
        if let model = model.programSearchModel {
            view?.updateTextFieldPlaceHolder(with: L10n.Localizable.Search.placeholder(model.category.title))
        }
    }
    
    // MARK: - Action
    func userInputButtonTapped() {
        guard let model = model.programSearchModel else { return }
        
        if let searchText, searchText.isNotEmpty {
            let program = Program(category: model.category, title: searchText)
            moveWriteReview(with: program)
        } else {
            showToastWithEndEditing(L10n.Localizable.Search.toast(model.category.title))
        }
    }
    
    func selectProgram(at index: Int) {
        if let program = program(at: index) {
            moveWriteReview(with: program)
        }
    }
    
    func searchNextProgram() {
        guard let model = model.programSearchModel else { return }
        
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
        let appModel = AppModels(
            writeReviewModel: WriteReviewModel(provider, program: program)
        )
        let presenter = WriteReviewViewPresenter(with: provider, model: appModel, delegate: delegate)
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
              text != model.programSearchModel?.lastSearchText ?? "" else { return true }
        view?.endEditing()
        view?.updateLoadingView(isLoading: true)
        model.programSearchModel?.search(text)
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
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        showToastWithEndEditing(L10n.Localizable.Error.title("검색") + "\n" + L10n.Localizable.Error.message)
    }
    
    func programSearchModel(_ model: ProgramSearchModelType, didChange programs: [Program]) {
        view?.updateLoadingView(isLoading: false)
        view?.reloadTableView()
        view?.endEditing()
        view?.updateEmptyResultViewHidden(!programs.isEmpty)
    }
    
    func programSearchDidLast(_ model: ProgramSearchModelType) {
        view?.updateLoadingView(isLoading: false)
    }
}
