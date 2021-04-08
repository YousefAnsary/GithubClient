//
//  RepositoriesService.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class RepositoriesService {
    
    class func getRepositories(completion: @escaping(Result<[Repository], Error>)-> Void) {
        
//        var params = ["page": String(page), "per_page": "10"]
//        if name != nil { params["q"] = name! }
        
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
                let repositories = try JSONHelper.shared.decode(data, to: [Repository].self)
                completion(.success(repositories))
            } catch (let error) {
                completion(.failure(APIError.decodingFailed(error: error)))
            }
            
        }
    }
    
    class func getRepositories(withName name: String? = nil, page: Int,
                               completion: @escaping(Result<RepositoriesResponse, Error>)-> Void) {
        
        var params = ["page": String(page), "per_page": "10"]
        if name != nil { params["q"] = name! }
        
        APIManager.default.get(path: "search/repositories", parameters: params) { data, res, err in
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
                let repositories = try JSONHelper.shared.decode(data, to: RepositoriesResponse.self)
                completion(.success(repositories))
            } catch (let error) {
                completion(.failure(APIError.decodingFailed(error: error)))
            }
            
        }
    }
    
}
