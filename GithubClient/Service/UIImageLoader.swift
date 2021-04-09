//
//  ImageLoader.swift
//  GithubClient
//
//  Created by Yousef on 4/9/21.
//

import UIKit

class UIImageLoader {
    
    static let loader = UIImageLoader()
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ url: URL, for imageView: UIImageView) {
        
        let token = imageLoader.loadImage(url) { result in
            
            defer { self.uuidMap.removeValue(forKey: imageView) }
            
            let image = try? result.get()
            DispatchQueue.main.async {
                imageView.image = image
            }
            
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
        
    }
    
    func cancel(for imageView: UIImageView) {
        
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
        
    }
    
}
