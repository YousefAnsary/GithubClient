//
//  Owner.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

struct Owner: Codable {
    let login: String?
    let id: Int?
    let avatarURL: String?
    let url, htmlURL: String?
    let type: UserType?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case type
    }
}
