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
}
class AppVersionViewPresenter: Presenter, AppVersionPresenter {
    weak var view: AppVersionView?
}

extension AppVersionViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        let currentVersion: String = Utils.getAppVersion() ?? ""
        let versionInfo = "현재 버전은 \(currentVersion) 이에요."
        let updateInfo = "가장 최신 버전이에요."
        
        view?.updateLabelsText(versionInfo: versionInfo, updateInfo: updateInfo)
        view?.updateUpdateButtonHidden(true)
    }
    
    // MARK: - Action
    
    // MARK: - Logic
}
