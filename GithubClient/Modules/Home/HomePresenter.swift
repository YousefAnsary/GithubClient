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
    private var page = 1
    
    var repositoriesCount: Int {
        repositories?.count ?? 0
    }
    
    init(delegate: HomeDelegate, repository: RepositoriesRepository) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func getRepositories() {
        repository.loadRemotely(page: page) { [unowned self] res in
            switch res {
            case .success(let data):
                self.repositoriesFetchSuccess(data)
            case .failure(let err):
                self.repositoriesFetchFailed(err)
            }
        }
    }
    
    func paginate() {
        page += 1
        getRepositories()
    }
    
    func refresh() {
        page = 1
        getRepositories()
    }
    
    private func repositoriesFetchSuccess(_ data: [Repository]) {
        if page == 1 {
            self.repositories = data
        } else {
            self.repositories?.append(contentsOf: data)
        }
        DispatchQueue.main.async {
            self.delegate?.repositoriesDidLoad()
        }
    }
    
    private func repositoriesFetchFailed(_ error: Error) {
        DispatchQueue.main.async {
            self.delegate?.repositoriesFetchDidFailed(withError: error)
        }
    }
    
    func setupCell(_ cell: inout RepositoryCell, atIndex index: IndexPath) {
        guard index.row < repositories?.count ?? 0,
              let item = repositories?[index.row] else { return }
        
        cell.configureCell(imgURL: item.owner?.avatarURL ?? "", name: item.name,
                           owner: "Creator: \(item.owner?.login ?? "")", creationDate: item.createdAt)
    }
    
}
