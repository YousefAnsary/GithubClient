//
//  RepositoriesService.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class RepositoriesService {
    
    /// Calls Github API to fetch public repos
    /// - Parameters:
    ///   - locally: False by default, if set to true it loads local faked response
    ///   - completion: Result Closure which is fired on completion of request
    class func getRepositories(locally: Bool = false, completion: @escaping(Result<[Repository], Error>)-> Void) {
        if locally {
            let repos = fetchLocally()
            completion(repos == nil ? .failure(APIError.other(statusCode: 0, data: nil, error: nil)) : .success(repos!))
        } else {
            fetchRemotely(completion: completion)
        }
    }
    
    private class func fetchRemotely(completion: @escaping(Result<[Repository], Error>)-> Void) {
        APIManager.default.get(path: "repositories", parameters: nil) { _data, res, err in
            guard err == nil else {
                completion(.failure(err!))
                return
            }
            let statusCode = (res as? HTTPURLResponse)?.statusCode ?? 0
            guard 200...299 ~= statusCode, let data = _data else {
                completion(.failure(APIError(rawValue: statusCode, data: _data)))
                return
            }
            
            do {
                let repositories = try JSONHelper.shared.decode(data, to: [Repository].self)
                completion(.success(repositories))
            } catch (let error) {
                completion(.failure(APIError.decodingFailed(error: error)))
            }
        }
    }
    
    private class func fetchLocally()-> [Repository]? {
        guard let path = Bundle.main.path(forResource: "Response", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let repos = try? JSONHelper.shared.decode(data, to: [Repository].self) else {
            return nil
        }
        return repos
    }
    
}
