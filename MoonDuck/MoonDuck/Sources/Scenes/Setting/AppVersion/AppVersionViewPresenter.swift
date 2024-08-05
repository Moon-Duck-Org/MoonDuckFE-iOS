//
//  AppVersionViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import Foundation

protocol AppVersionPresenter: AnyObject {
    var view: AppVersionView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func updateButtonTapped()
}
class AppVersionViewPresenter: BaseViewPresenter, AppVersionPresenter {
    weak var view: AppVersionView?
    private var storeVersion: String?
}

extension AppVersionViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        checkForUpdate()
    }
    
    // MARK: - Action
    func updateButtonTapped() {
        let currentVersion: String = Constants.appVersion
        AnalyticsService.shared.logEvent(
            .TAP_APPVERSION_UPDATE_GO,
            parameters: [.APP_VERSION: currentVersion,
                         .STORE_VERSION: storeVersion ?? ""])
        
        Utils.moveAppStore()
    }
    
    // MARK: - Logic
    private func checkForUpdate() {
        let currentVersion: String = Constants.appVersion
        let versionInfo = L10n.Localizable.Update.versionText(currentVersion)
        
        Utils.checkForUpdate { [weak self] appUpdate, storeVersion in
            AnalyticsService.shared.logEvent(
                .VIEW_APPVERSION,
                parameters: [.APP_VERSION: currentVersion,
                             .STORE_VERSION: storeVersion ?? ""])
            self?.storeVersion = storeVersion
            DispatchQueue.main.async {
                if appUpdate == .none {
                    let updateInfo = L10n.Localizable.Update.latestVersionText
                    self?.view?.updateLabelsText(versionInfo: versionInfo, updateInfo: updateInfo)
                    self?.view?.updateUpdateButtonHidden(true)
                } else {
                    let updateInfo = L10n.Localizable.Update.latestUpdateText
                    self?.view?.updateLabelsText(versionInfo: versionInfo, updateInfo: updateInfo)
                    self?.view?.updateUpdateButtonHidden(false)
                }
            }
        }
    }
}
