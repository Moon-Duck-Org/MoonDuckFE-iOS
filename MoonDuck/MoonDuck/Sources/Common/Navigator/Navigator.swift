//
//  Navigator.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator? { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    var root: UIViewController {
        return self.rootViewController
    }
    
    private lazy var rootViewController: BaseNavigationController = {
        let viewController = BaseNavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    // MARK: - all app scenes
    enum Scene {
        case intro(presenter: IntroPresenter)
        case login(presenter: LoginPresenter)
        case nameSetting(presenter: NicknameSettingPresenter)
        case home(presenter: V2HomePresenter)
        case myInfo(presenter: MyInfoPresenter)
        case selectProgram(presenter: SelectProgramPresenter)
        case programSearch(presenter: ProgramSearchPresenter)
        case writeReview(presenter: WriteReviewPresenter)
        case reviewDetail(presenter: ReviewDetailPresenter)
    }

    enum Transition {
        case root
        case navigation
        case modal
        case popup
        case alert
        case customNavigation
    }
    
    enum PopType {
        case pop
        case popToRoot
        case popToSelf
    }
    
    func get(seque: Scene) -> UIViewController? {
        switch seque {
        case .intro(let presenter):
            return IntroViewController(navigator: self, presenter: presenter)
        case .login(let presenter):
            return LoginViewController(navigator: self, presenter: presenter)
        case .nameSetting(let presenter):
            return NicknameSettingViewController(navigator: self, presenter: presenter)
        case .home(let presenter):
            return V2HomeViewController(navigator: self, presenter: presenter)
        case .myInfo(let presenter):
            return MyInfoViewController(navigator: self, presenter: presenter)
        case .selectProgram(let presenter):
            return SelectProgramViewController(navigator: self, presenter: presenter)
        case .programSearch(let presenter):
            return ProgramSearchViewController(navigator: self, presenter: presenter)
        case .writeReview(let presenter):
            return WriteReviewViewController(navigator: self, presenter: presenter)
        case .reviewDetail(let presenter):
            return ReviewDetailViewController(navigator: self, presenter: presenter)
        }
    }
    
    func pop(sender: UIViewController?, popType: PopType = .pop, animated: Bool = false) {
        switch popType {
        case .pop:
            sender?.navigationController?.popViewController(animated: animated)
        case .popToRoot:
            sender?.navigationController?.popToRootViewController(animated: animated)
        case .popToSelf:
            if let sender {
                sender.navigationController?.popToViewController(sender, animated: animated)
            }
        }
    }

    func dismiss(sender: UIViewController?, animated: Bool = false) {
        sender?.navigationController?.dismiss(animated: animated, completion: nil)
    }
    
    // MARK: - invoke a single segue
    func show(seque: Scene, sender: UIViewController?, transition: Transition = .navigation, animated: Bool = true) {
        if let target = get(seque: seque) {
            show(target: target, sender: sender, transition: transition, animated: animated)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition, animated: Bool) {
        switch transition {
        case .root:
            rootViewController.setViewControllers([target], animated: animated)
            return
        case .customNavigation:
            return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("sender is nil")
        }
        
        switch transition {
        case .navigation:
            DispatchQueue.main.async {
                self.rootViewController.pushViewController(target, animated: animated)
            }
        case .modal:
            DispatchQueue.main.async {
                target.modalPresentationStyle = .fullScreen
                sender.present(target, animated: animated)
            }
        case .popup:
            return
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: animated, completion: nil)
            }
            return
        default: break
        }
    }
}
