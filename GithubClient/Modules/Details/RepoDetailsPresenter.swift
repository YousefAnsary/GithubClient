//
//  DetailsPresenter.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import Foundation

protocol RepoDetailsDelegate: Delegate {
    func setData(_ data: RepoDetailsVM)
}

class RepoDetailsPresenter {
    
    weak var delegate: RepoDetailsDelegate?
    private var repository: Repository
    
    init(delegate: RepoDetailsDelegate, repository: Repository) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func getRepoDetails() {
        DispatchQueue.global(qos: .background).async {
            if self.repository.createdAt == nil {
                self.repository.loadDetails()
            }
            DispatchQueue.main.async {
                self.delegate?.setData(RepoDetailsVM(repository: self.repository))
            }
        }
        
    }
    
}
