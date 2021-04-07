//
//  ImageLoader.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class ImageLoader {
    
    private static let imageCache = NSCache<AnyObject, UIImage>()
    
    public static func downloadImage(url: String, completion: @escaping (Result<UIImage, Error>)-> Void) {
        
        if let cachedImage = ImageLoader.cachedImage(forUrl: url) {
            completion(.success(cachedImage))
            return
        }
        
        APIManager.default.get(URL: url, parameters: nil) { (data, res, err) in
            guard err != nil else { completion(.failure(err!)); return }
            guard let data = data, let img = UIImage(data: data) else {
                completion(.failure(APIError.invalidURL(url: url)))
                return
            }
            completion(.success(img))
        }
        
    }
    
    static func clearCache(forUrl url: String) {
        imageCache.removeObject(forKey: url as AnyObject)
    }
    
    static func clearCache() {
        imageCache.removeAllObjects()
    }
    
    static func cache(image: UIImage, url: String) {
        imageCache.setObject(image, forKey: url as AnyObject)
    }
    
    static func cachedImage(forUrl url: String)-> UIImage? {
        return imageCache.object(forKey: url as AnyObject)
    }
    
}
