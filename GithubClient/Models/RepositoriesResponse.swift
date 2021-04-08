//
//  RepositoriesResponse.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import Foundation

struct RepositoriesResponse: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Repository]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
