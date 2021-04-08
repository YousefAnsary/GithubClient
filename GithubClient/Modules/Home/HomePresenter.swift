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
    private var searchKeyword = ""
//    private var searchTask: DispatchWorkItem?
    
    var repositoriesCount: Int {
        repositories?.count ?? 0
    }
    
    init(delegate: HomeDelegate, repository: RepositoriesRepository) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func getRepositories() {
        repository.fetchRepos(page: page) { [unowned self] res in
            switch res {
            case .success(let data):
                self.repositoriesFetchSuccess(data)
            case .failure(let err):
                self.repositoriesFetchFailed(err)
            }
        }
    }
    
    func searchRepositories(withName name: String) {
//        self.searchTask?.cancel()
//        self.searchTask = DispatchWorkItem {
//            self.searchRepositories(name: name)
//        }
//        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5, execute: self.searchTask!)
        searchRepositories(name: name)
        
    }
    
    private func searchRepositories(name: String) {
        page = 1
        
        guard !name.isEmpty else {
            getRepositories()
            return
        }
        
        if name.count == 1 {
            self.repositories = []
            delegate?.repositoriesDidLoad()
            return
        }
        
        repository.fetchRepos(withName: name, page: page) { res in
            switch res {
            case .success(let data):
                self.repositories = data
                self.delegate?.repositoriesDidLoad()
            case .failure(let err):
                self.delegate?.repositoriesFetchDidFailed(withError: err)
            }
        }
    }
    
    func paginateRepositories(withName name: String) {
        repository.fetchRepos(withName: name, page: page) { res in
            switch res {
            case .success(let data):
                self.repositories?.append(contentsOf: data)
                self.delegate?.repositoriesDidLoad()
            case .failure(let err):
                self.delegate?.repositoriesFetchDidFailed(withError: err)
            }
        }
    }
    
    func paginate() {
        page += 1
        if searchKeyword == "" {
            getRepositories()
        } else {
            paginateRepositories(withName: searchKeyword)
        }
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
