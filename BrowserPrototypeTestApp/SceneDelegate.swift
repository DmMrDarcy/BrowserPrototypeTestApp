//
//  SceneDelegate.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 03.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let environment = AppEnvironment.bootstrap()
        
        let navVC = UINavigationController()
        let coordinator = MainCoordinator(container: environment.container)
        coordinator.navigationController = navVC
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
        
        coordinator.start()
    }
}
