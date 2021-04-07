//
//  RepositoriesService.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class RepositoriesService {
    
    class func getRepositories(completion: @escaping(Result<[Repository], Error>)-> Void) {
        APIManager.default.get(path: "repositories", parameters: nil) { data, res, err in
            guard err == nil else {
                completion(.failure(err!))
                return
            }
            let statusCode = (res as? HTTPURLResponse)?.statusCode ?? 0
            guard 200...299 ~= statusCode else {
                completion(.failure(APIError(rawValue: statusCode, data: data)))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.other(statusCode: statusCode, data: nil, error: err)))
                return
            }
            
            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repositories))
            } catch (let error) {
                completion(.failure(APIError.decodingFailed(error: error)))
            }
            
        }
    }
    
}
