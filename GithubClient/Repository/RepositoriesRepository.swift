//
//  RepositoriesRepository.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class RepositoriesRepository {
    
    private var repositories = [Repository]()
    
    func loadRemotely(completion: @escaping(Result<[Repository], Error>)-> Void) {
        RepositoriesService.getRepositories { res in
            completion(res)
            if case let .success(data) = res {
                self.repositories = data
            }
        }
    }
    
}
