//
//  RepoDetailsVM.swift
//  GithubClient
//
//  Created by Yousef on 4/9/21.
//

import Foundation

struct RepoDetailsVM {
    let name, language, creationDate, description: String?
    let ownerName, avatarURL: String?
    let issuesCount, starGazersCount: Int?
    
    init(repository: Repository) {
        self.name = repository.name
        self.language = repository.language
        self.creationDate = repository.createdAt
        self.description = repository.itemDescription
        self.ownerName = repository.owner?.login
        self.avatarURL = repository.owner?.avatarURL
        self.issuesCount = repository.openIssues
        self.starGazersCount = repository.stargazersCount
    }
}
