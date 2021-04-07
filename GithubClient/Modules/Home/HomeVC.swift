//
//  ViewController.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class HomeVC: BaseViewController {

    @IBOutlet private weak var repositoriesTV: UITableView!
    var presenter: HomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupTableView() {
        repositoriesTV.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        repositoriesTV.delegate = self
        repositoriesTV.dataSource = self
        let refreshControl = UIRefreshControl()
        repositoriesTV.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        
    }


}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        return cell
    }
    
}

