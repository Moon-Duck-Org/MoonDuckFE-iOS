//
//  Navigator.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator! { get set }
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
        case intro(presenter: IntroViewPresenter)
        case login(presenter: LoginViewPresenter)
        case nameSetting(presenter: NameSettingViewPresenter)
        case home(presenter: HomeViewPresenter)
        case boardDetail(presenter: BoardDetailViewPresenter)
        case boardEdit(presenter: BoardEditViewPresenter)
    }

    enum Transition {
        case root
        case navigation
        case modal
        case popup
        case alert
        case custom
    }
    
    func get(seque: Scene) -> UIViewController? {
        switch seque {
        case .intro(let presenter):
            return IntroViewController(navigator: self, presenter: presenter)
        case .login(let presenter):
            return LoginViewController(navigator: self, presenter: presenter)
        case .nameSetting(let presenter):
            return NameSettingViewController(navigator: self, presenter: presenter)
        case .home(let presenter):
            return HomeViewController(navigator: self, presenter: presenter)
        case .boardDetail(let presenter):
            return BoardDetailViewController(navigator: self, presenter: presenter)
        case .boardEdit(let presenter):
            return BoardEditViewController(navigator: self, presenter: presenter)
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - invoke a single segue
    func show(seque: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = get(seque: seque) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root:
            rootViewController.setViewControllers([target], animated: false)
            return
        case .custom:
            return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("sender is nil")
        }
        
        switch transition {
        case .navigation:
            DispatchQueue.main.async {
                self.rootViewController.pushViewController(target, animated: true)
            }
        case .modal:
            DispatchQueue.main.async {
                target.modalPresentationStyle = .overFullScreen
                target.modalTransitionStyle = .crossDissolve
                sender.present(target, animated: true)
            }
        case .popup:
            return
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
            return
        default: break
        }
    }
}
