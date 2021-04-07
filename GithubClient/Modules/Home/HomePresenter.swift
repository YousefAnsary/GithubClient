//
//  HomePresenter.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

protocol HomeDelegate: class {
    func repositoriesDidLoad()
    func repositoriesFetchDidFailed(withError error: Error)
}

class HomePresenter {
    
    private weak var delegate: HomeDelegate?
    private let repository: RepositoriesRepository
    private var repositories: [Repository]?
    var repositoriesCount: Int {
        repositories?.count ?? 0
    }
    
    init(delegate: HomeDelegate, repository: RepositoriesRepository) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func getRepositories() {
        repository.loadRemotely { [unowned self] res in
            switch res {
            case .success(let data):
                self.repositories = data
                DispatchQueue.main.async {
                    self.delegate?.repositoriesDidLoad()
                }
                
            case .failure(let err):
                DispatchQueue.main.async {
                    self.delegate?.repositoriesFetchDidFailed(withError: err)
                }
            }
        }
        
    }
    
    func setupCell(_ cell: inout RepositoryCell, atIndex index: IndexPath) {
        guard index.row < repositories?.count ?? 0,
              let item = repositories?[index.row] else { return }
        
        cell.configureCell(imgURL: item.owner?.avatarURL ?? "", name: item.name, owner: item.owner?.login, creationDate: "Test")
    }
    
}
