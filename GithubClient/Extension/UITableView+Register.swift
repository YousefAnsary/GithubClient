//
//  UITableView+Register.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }

    func dequeue<T: UITableViewCell>()-> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
    
}
