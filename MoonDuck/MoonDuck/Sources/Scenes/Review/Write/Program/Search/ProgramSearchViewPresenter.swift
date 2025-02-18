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
    
    private var searchText: String?
    
    override init(with provider: AppStorages,
         model: AppModels) {
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
        
        if let category = model.programSearchModel?.category {
            // LOG
            switch category {
            case .movie: AnalyticsService.shared.logEvent(.VIEW_SEARCH_PROGRAM_MOVIE)
            case .drama: AnalyticsService.shared.logEvent(.VIEW_SEARCH_PROGRAM_DRAMA)
            case .book: AnalyticsService.shared.logEvent(.VIEW_SEARCH_PROGRAM_BOOK)
            case .concert: AnalyticsService.shared.logEvent(.VIEW_SEARCH_PROGRAM_CONCERT)
            default: break
            }
            
            view?.updateTextFieldPlaceHolder(with: L10n.Localizable.Search.placeholder(category.title))
        }
    }
    
    // MARK: - Action
    func userInputButtonTapped() {
        guard let model = model.programSearchModel else { return }
        
        if let searchText, searchText.isNotEmpty {
            // LOG
            switch model.category {
            case .movie:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_MOVIE_USERINPUT,
                    parameters: [.PROGRAM_NAME: searchText]
                )
            case .drama:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_DRAMA_USERINPUT,
                    parameters: [.PROGRAM_NAME: searchText]
                )
            case .book:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_BOOK_USERINPUT,
                    parameters: [.PROGRAM_NAME: searchText]
                )
            case .concert:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_CONCERT_USERINPUT,
                    parameters: [.PROGRAM_NAME: searchText]
                )
            default: break
            }
            
            let program = Program(category: model.category, title: searchText)
            moveWriteReview(with: program)
        } else {
            showToastWithEndEditing(L10n.Localizable.Search.toast(model.category.title))
        }
    }
    
    func selectProgram(at index: Int) {
        if let program = program(at: index) {
            // LOG
            switch program.category {
            case .movie:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_MOVIE_INPUT,
                    parameters: [.PROGRAM_NAME: program.title]
                )
            case .drama:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_DRAMA_INPUT,
                    parameters: [.PROGRAM_NAME: program.title]
                )
            case .book:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_BOOK_INPUT,
                    parameters: [.PROGRAM_NAME: program.title]
                )
            case .concert:
                AnalyticsService.shared.logEvent(
                    .TAP_SEARCH_PROGRAM_CONCERT_INPUT,
                    parameters: [.PROGRAM_NAME: program.title]
                )
            default: break
            }
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
            reviewModel: ReviewModel(provider)
        )
        let presenter = WriteReviewViewPresenter(with: provider, model: appModel, program: program, editReview: nil)
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
        
        // LOG
        if let category = model.programSearchModel?.category {
            let parameters: [AnalyticsService.EventParameter: Any] = [.PROGRAM_NAME: text]
            switch category {
            case .movie: AnalyticsService.shared.logEvent(.TAP_SEARCH_PROGRAM_MOVIE, parameters: parameters)
            case .drama: AnalyticsService.shared.logEvent(.TAP_SEARCH_PROGRAM_DRAMA, parameters: parameters)
            case .book: AnalyticsService.shared.logEvent(.TAP_SEARCH_PROGRAM_BOOK, parameters: parameters)
            case .concert: AnalyticsService.shared.logEvent(.TAP_SEARCH_PROGRAM_CONCERT, parameters: parameters)
            default: break
            }
        }
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
