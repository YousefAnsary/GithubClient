//
//  UIImageView+Loader.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

extension UIImageView {
    
    ///Sets image for given url from cache, if not found image will be downloaded
    func loadImage(fromUrl url: URL?, defaultImage: UIImage? = nil) {
        guard let urlObject = url else {
            print("Error fetching Image from URL: \(url!)")
            self.image = defaultImage
            return
        }
      UIImageLoader.loader.load(urlObject, for: self)
    }

    ///Cancels current loading task
    func cancelImageLoad() {
      UIImageLoader.loader.cancel(for: self)
    }
//    func loadImage(fromURL url: String, defaultImage: UIImage? = nil) {
//        let activityIndicator = UIActivityIndicatorView(style: .white)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.hidesWhenStopped = true
//        self.addSubview(activityIndicator)
//        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        
//        activityIndicator.startAnimating()
//        
//        ImageLoader.downloadImage(url: url) { res in
//            DispatchQueue.main.async {
//                activityIndicator.stopAnimating()
//                activityIndicator.removeFromSuperview()
//                switch res {
//                case .success(let img):
//                    self.image = img
//                case .failure(_):
//                    self.image = defaultImage
//                }
//            }
//            
//        }
//        
//    }
    
}
