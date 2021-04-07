//
//  UIViewController+.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}
