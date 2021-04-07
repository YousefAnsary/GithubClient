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
        let vc = HomeVC(nibName: "HomeView", bundle: nil)
        vc.presenter = HomePresenter(delegate: vc, repository: RepositoriesRepository())
        navigationController.pushViewController(vc, animated: true)
        window.rootViewController = navigationController
    }
    
}
