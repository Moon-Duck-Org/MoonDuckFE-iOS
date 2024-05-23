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
    }

    enum Transition {
        case root
        case navigation
        case modal
        case popup
        case alert
        case custom
    }
    
    func get (seque: Scene) -> UIViewController? {
        switch seque {
        case .intro: return IntroViewController(nibName: "IntroViewController", bundle: nil)
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
            fatalError()
        }
        
        switch transition {
        case .navigation:
            rootViewController.pushViewController(target, animated: true)
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
