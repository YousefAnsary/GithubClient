//
//  ImageLoader.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//
//
import UIKit

class ImageLoader {
    
    private var loadedImages = NSCache<AnyObject, UIImage>()//[URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func cache(image: UIImage, url: String) {
        loadedImages.setObject(image, forKey: url as AnyObject)
    }
    
    func cachedImage(forUrl url: String)-> UIImage? {
        return loadedImages.object(forKey: url as AnyObject)
    }
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = cachedImage(forUrl: url.absoluteString) {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            defer {self.runningRequests.removeValue(forKey: uuid) }
            
            if let data = data, let image = UIImage(data: data) {
                self.cache(image: image, url: url.absoluteString)
                completion(.success(image))
                return
            }
            
            guard error == nil else { completion(.failure(error!)); return }
            
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
    
}
