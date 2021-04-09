//
//  AppCoordinator.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        window.rootViewController = navigationController
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
}
