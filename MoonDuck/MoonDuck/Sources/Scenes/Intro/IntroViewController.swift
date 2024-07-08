//
//  IntroViewController.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

protocol IntroView: BaseView {
    // UI Logic
    func showForceUpdateAlert()
    func showLatestUpdateAlert()
    
    // Navigation
    func moveNameSetting(with presenter: NicknameSettingPresenter)
    func moveHome(with presenter: HomePresenter)
}

class IntroViewController: BaseViewController, IntroView {
    let presenter: IntroPresenter
    
    init(navigator: Navigator,
         presenter: IntroPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: IntroViewController.className, bundle: Bundle(for: IntroViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.viewDidLoad()
    }
}
// MARK: - UI Logic
extension IntroViewController {
    func showForceUpdateAlert() {
        AppAlert.default.showDone(
            self,
            title: "업데이트가 필요합니다",
            message: "문덕이를 계속 사용하려면 새로운 버전으로 업데이트해야 해요. 지금 바로 업데이트 해주세요!",
            doneTitle: "업데이트 하러가기",
            doneHandler: {
                Utils.moveAppStore()
            })
    }
    
    func showLatestUpdateAlert() {
        AppAlert.default.showCancelAndDone(
            self,
            title: "새로운 버전 업데이트가 있어요",
            message: "문덕이의 새로운 기능과 개선된 성능을 경험할 수 있어요. 앱을 지금 최신 버전으로 업데이트 해보세요!",
            cancelTitle: "업데이트 하러가기",
            doneTitle: "나중에 하기",
            cancelHandler: { [weak self] in
                Utils.moveAppStore()
                self?.presenter.latestUpdateButtonTapped()
            },
            doneHandler: { [weak self] in
                self?.presenter.latestUpdateButtonTapped()
            })
    }
}

// MARK: - Navigation
extension IntroViewController {
    func moveNameSetting(with presenter: NicknameSettingPresenter) {
        navigator?.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root, animated: false)
    }
    
    func moveHome(with presenter: HomePresenter) {
        navigator?.show(seque: .home(presenter: presenter), sender: nil, transition: .root, animated: false)
    }
}
