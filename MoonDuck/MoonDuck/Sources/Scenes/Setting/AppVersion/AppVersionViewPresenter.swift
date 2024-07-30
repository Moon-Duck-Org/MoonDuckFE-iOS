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
}

extension AppVersionViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        checkForUpdate()
    }
    
    // MARK: - Action
    func updateButtonTapped() {
        Utils.moveAppStore()
    }
    
    // MARK: - Logic
    private func checkForUpdate() {
        let currentVersion: String = Constants.appVersion
        let versionInfo = L10n.Localizable.Update.versionText(currentVersion)
        
        Utils.checkForUpdate { [weak self] appUpdate in
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
