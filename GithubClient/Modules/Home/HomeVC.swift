//
//  ViewController.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class HomeVC: BaseViewController {

    @IBOutlet private weak var repositoriesTV: UITableView!
    private var refreshControl: UIRefreshControl!
    var presenter: HomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        startLoading()
        presenter?.getRepositories()
    }
    
    private func setupTableView() {
        repositoriesTV.register(RepositoryCell.self)
        repositoriesTV.delegate = self
        repositoriesTV.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        repositoriesTV.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repos"
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    @objc func refresh() {
        presenter?.getRepositories()
    }


}

extension HomeVC: HomeDelegate {
    
    func repositoriesDidLoad() {
        dismissLoader()
        refreshControl.endRefreshing()
        repositoriesTV.reloadData()
    }
    
    func repositoriesFetchDidFailed(withError error: Error) {
        dismissLoader()
        refreshControl.endRefreshing()
        self.handleError(error: error)
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.repositoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RepositoryCell = tableView.dequeue()
        presenter?.setupCell(&cell, atIndex: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        145
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter!.repositoriesCount - 1 {
            startLoading()
            presenter?.paginate()
        }
    }
    
}

extension HomeVC: UISearchResultsUpdating {
    
  func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text!
//    guard text.count >= 2 else {
//        presenter?.refresh()
//        return
//    }
    presenter?.searchRepositories(withName: text)
  }
    
}

