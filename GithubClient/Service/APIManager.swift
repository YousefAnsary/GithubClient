//
//  API.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class APIManager {
    
    private let baseURL: String
    static let `default` = APIManager()
    
    private init() {
        guard let path = Bundle.main.path(forResource: "API", ofType: "plist"),
              let myDict = NSDictionary(contentsOfFile: path),
              let baseUrl = myDict.object(forKey: "BaseURL") as? String else {
                fatalError("BaseURL not found in API.plist")
        }
        self.baseURL = baseUrl
    }
    
    func get(URL: String, parameters: [String: String]?, completion: @escaping (Data?, URLResponse?, Error?)-> Void) {
        guard var urlComponents = URLComponents(string: URL) else { completion(nil, nil, APIError.invalidURL(url: URL)); return }
        urlComponents.query = queryString(fromDict: parameters)
        
        guard let url = urlComponents.url else { completion(nil, nil, APIError.invalidURL(url: URL)); return }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            completion(data, res, err)
        }.resume()
        
    }
    
    func get(path: String, parameters: [String: String]?, completion: @escaping (Data?, URLResponse?, Error?)-> Void) {
        let fullURL = baseURL + path
        get(URL: fullURL, parameters: parameters, completion: completion)
    }
    
    func getImage(fromURL url: String, completion: ()-> Void) {
        
    }
    
    private func queryString(fromDict dict: [String: Any]?)-> String? {
        return dict?.map { key, val in "\(key)=\(val)" }.joined(separator: "&")
    }
    
}
