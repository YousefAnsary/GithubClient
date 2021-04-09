//
//  HomeCoordinator.swift
//  GithubClient
//
//  Created by Yousef on 4/9/21.
//

import UIKit

class HomeCoordinator {
    
    private let navigationController: UINavigationController
    private var presenter: HomePresenter?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeVC(nibName: "HomeView", bundle: nil)
        let repository = RepositoriesRepository()
        self.presenter = HomePresenter(delegate: vc, repository: repository)
        vc.presenter = presenter
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToDetails(forRepoAtIndex index: Int) {
        let coordinator = RepoDetailsCoordinator(navigationController: navigationController)
        guard let repo = presenter!.repository(atIndex: index) else { return }
        coordinator.start(repo: repo)
    }
    
}
