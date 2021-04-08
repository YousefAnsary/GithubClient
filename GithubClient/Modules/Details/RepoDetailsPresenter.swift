//
//  DetailsPresenter.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import Foundation

protocol RepoDetailsDelegate: class {
    
}

class RepoDetailsPresenter {
    
    weak var delegate: RepoDetailsDelegate?
    private var repository: Repository
    
    init(delegate: RepoDetailsDelegate, repository: Repository) {
        self.delegate = delegate
        self.repository = repository
    }
    
}
