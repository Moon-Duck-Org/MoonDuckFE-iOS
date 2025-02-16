//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

import FirebaseRemoteConfig

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func latestUpdateButtonTapped()
    func notionCloseButtonTapped()
}

class IntroViewPresenter: BaseViewPresenter, IntroPresenter {
    
    weak var view: IntroView?
    private var launchedFromPush: Bool
    private var launchedFromDeeplink: Bool
    
    init(with provider: AppStorages, 
         model: AppModels,
         launchedFromPush: Bool = false, launchedFromDeeplink: Bool = false) {
        self.launchedFromPush = launchedFromPush
        self.launchedFromDeeplink = launchedFromDeeplink
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
    }
}

extension IntroViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        if Utils.isJailbroken() {
            view?.showJalibrokenAlert()
        } else {
            startApp()
        }
    }
    
    // MARK: - Action
    func latestUpdateButtonTapped() {
        checkUserData()
    }
    
    func notionCloseButtonTapped() {
        checkUserData()
    }
}
// MARK: - Logic
extension IntroViewPresenter {
    private func startApp() {
        AnalyticsService.shared.logEvent(.OPEN_APP, parameters: [
            .TIME_STAMP: Utils.getCurrentKSTTimestamp()
        ])
        
        if self.launchedFromPush {
            AnalyticsService.shared.logEvent(.OPEN_APP_PUSH, parameters: [
                .TIME_STAMP: Utils.getCurrentKSTTimestamp()
            ])
        }
        
        if self.launchedFromDeeplink {
            AnalyticsService.shared.logEvent(.OPEN_APP_DEEPLINK, parameters: [
                .TIME_STAMP: Utils.getCurrentKSTTimestamp()
            ])
        }
        Utils.initConfig()
        Utils.checkForUpdate { [weak self] appUpdate, _ in
            switch appUpdate {
            case .forceUpdate:
                self?.view?.showForceUpdateAlert()
            case .latestUpdate:
                self?.view?.showLatestUpdateAlert()
            case .none:
                self?.checkNoticePopup()
            }
        }
    }
    
    private func checkNoticePopup() {
        // TODO: - 다시 보지 않기 설정 확인 로직 추가
        self.view?.showNoticePopup()
    }
    
    private func checkUserData() {
        if AppUserDefaults.getObject(forKey: .appInstalledAt) as? Date == nil {
            // 앱 첫 실행 시, 세팅
            AppUserDefaults.set(Date(), forKey: .appInstalledAt)
        }
        
        let appModel = AppModels(
            userModel: model.userModel,
            categoryModel: CategoryModel(),
            sortModel: SortModel(),
            reviewModel: ReviewModel(provider)
//            shareModel: ShareModel(provider)
        )
        
        if model.userModel?.user.nickname == nil {
            // 닉네임 미설정 case
            let presenter = NicknameSettingViewPresenter(with: provider, model: appModel, delegate: nil)
            self.view?.moveNameSetting(with: presenter)
        } else {
            let presenter = HomeViewPresenter(with: provider, model: appModel)
            self.view?.moveHome(with: presenter)
        }
    }
}

// MARK: - UserModelDelegate
extension IntroViewPresenter: UserModelDelegate {
    func userModel(_ model: UserModelType, didChange user: User) {
        
    }
}
