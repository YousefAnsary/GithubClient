//
//  RepoDetailsCoordinator.swift
//  GithubClient
//
//  Created by Yousef on 4/9/21.
//

import UIKit

class RepoDetailsCoordinator {
    
    private let navigationController: UINavigationController
    private var presenter: RepoDetailsPresenter?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(repo: Repository) {
        let vc = RepoDetailsVC(nibName: "RepoDetailsView", bundle: nil)
        self.presenter = RepoDetailsPresenter(delegate: vc, repository: repo)
        vc.presenter = presenter
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
