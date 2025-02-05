//
//  SceneDelegate.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var appService = {
        return AppServices(authService: AuthService(),
                           userService: UserService(),
                           reviewService: ReviewService(),
                           programSearchService: ProgramSearchService(), 
                           shareService: ShareService())
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        AuthManager.shared.initProvider(appService)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let launchedFromPush = appDelegate?.launchedFromPush ?? false
        let launchedFromDeeplink = appDelegate?.launchedFromDeeplink ?? false
        let navigator = Navigator.default
        let appModel = AppModels(userModel: UserModel(appService))
        let presenter = IntroViewPresenter(with: appService, model: appModel, launchedFromPush: launchedFromPush, launchedFromDeeplink: launchedFromDeeplink)
        navigator.show(seque: .intro(presenter: presenter), sender: nil, transition: .root)
        
        window?.windowScene = windowScene
        window?.rootViewController = navigator.root
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if let root = window?.rootViewController, Utils.remoteConfig != nil {
            Utils.checkForUpdate { appUpdate, _ in
                if appUpdate == .forceUpdate {
                    AppAlert.default.showDone(
                        root,
                        title: L10n.Localizable.Update.latestUpdateTitle,
                        message: L10n.Localizable.Update.latestUpdateMessage,
                        doneTitle: L10n.Localizable.Button.update,
                        doneHandler: {
                            Utils.moveAppStore()
                        })
                }
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
