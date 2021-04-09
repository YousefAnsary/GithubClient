//
//  Repository.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class Repository: Codable {
    let id: Int?
    let name, fullName: String?
    let owner: Owner?
    let htmlURL: String?
    let itemDescription: String?
    let url: String?
    var createdAt: String?
    var stargazersCount: Int?
    var language: String?
    var openIssues: Int?
    
    func loadDetails() {
        if self.createdAt != nil {return}
//        print(id!)
        guard let urlString = self.url, let url = URL(string: urlString) else {return}
        guard let data = try? Data(contentsOf: url),
              let dict = try? JSONHelper.shared.dictionary(fromData: data) else { return }
        self.createdAt = dict["created_at"] as? String
        self.language = dict["language"] as? String
        self.stargazersCount = dict["stargazers_count"] as? Int
        self.openIssues = dict["open_issues"] as? Int
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case url
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
        case language
        case openIssues = "open_issues"
    }
}

extension Array where Element == Repository {
    
    mutating func loadDetails() {
        for i in 0 ..< self.count {
            self[i].loadDetails()
        }
    }
    
}

extension ArraySlice where Element == Repository {
    
    mutating func loadDetails() {
        for i in startIndex ..< endIndex {
            self[i].loadDetails()
        }
    }
    
}
