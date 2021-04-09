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
    private var allRepos: [Repository]
    private var repos: [Repository]?
    private var pageSize = 10
    private var searchKeyword = ""
    private(set) var page = 1
    var repositoriesCount: Int {
        min(repos?.count ?? 0, page * pageSize)
    }
    var totalPages: Int {
        let reposCount = Double(repos?.count ?? 0)
        let numOfPages = reposCount / Double(pageSize)
        return Int(ceil(numOfPages))
    }
//    private var searchTask: DispatchWorkItem?
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
        self.allRepos = []
    }
    
    ///Loads repos and resets page to 1
    func fetchRepos() {
        page = 1
        RepositoriesService.getRepositories(locally: true){ res in
            switch res {
            case .success(let repos):
                self.reposDidFetched(repos)
            case .failure(let err):
                self.reposFetchFailed(withError: err)
            }
        }
    }
    
    ///Repos Fetch Success Handler
    private func reposDidFetched(_ repos: [Repository]) {
        self.allRepos = repos
        self.repos = repos
        delegateRepos()
    }
    
    ///Repos Fetch Failure Handler
    private func reposFetchFailed(withError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.repositoriesFetchDidFailed(withError: error)
        }
    }
    
    ///Increments page to load more repos
    func paginate() {
        page += 1
        delegateRepos()
    }
    
    ///Searches repos with given name
    func search(forReposWithName name: String) {
        
        //First time focus handle
        if name.count == 0 && searchKeyword.count == 0 { return }
        
        page = 1
        
        //Canceling search (Erasing typed keyword)
        if name.count == 0 && searchKeyword.count > 0 {
            repos = allRepos
            delegateRepos()
            self.searchKeyword = name
            return
        }
        
        //Empty list if only 1 char is typed (Business demand)
        if name.count == 1 {
            repos = []
            self.searchKeyword = name
            DispatchQueue.main.async {
                self.delegate?.repositoriesDidLoad()
            }
            return
        }
        
        //More than one char start search on background thread
        DispatchQueue.global(qos: .background).async {
            self.repos = self.allRepos.filter{ $0.name?.lowercased().contains(name.lowercased()) ?? false }
            self.delegateRepos()
            self.searchKeyword = name
        }
        
    }
    
    //
    private func delegateRepos() {
        DispatchQueue.global(qos: .background).async {
            var reposPage = self.repos?.items(inPage: self.page, pageSize: self.pageSize)
            reposPage?.loadDetails()
            DispatchQueue.main.async {
                self.delegate?.repositoriesDidLoad()
            }
        }
    }
    
    func refresh() {
        page = 1
        fetchRepos()
    }
    
    func repository(atIndex index: Int)-> Repository? {
        guard index < repos?.count ?? 0 else {return nil}
        return repos![index]
    }
    
    func setupCell(_ cell: inout RepositoryCell, atIndex index: IndexPath) {
        
        guard let item = repository(atIndex: index.row) else { return }
        
        cell.configureCell(imgURL: item.owner?.avatarURL ?? "", name: item.name,
                           owner: "Creator: \(item.owner?.login ?? "")", creationDate: item.createdAt)
    }
    
}
