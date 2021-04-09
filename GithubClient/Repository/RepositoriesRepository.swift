//
//  RepositoriesRepository.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class RepositoriesRepository {
    
    private var repositories = [Repository]()
    private var searchKeyword = ""
    private var filteredRepos = [Repository]()
    private let pageSize = 10
//    private var loadedPages = Set<Int>()
    
    func fetchRepos(page: Int, completion: @escaping(Result<[Repository], Error>)-> Void) {
        
        if !repositories.isEmpty {
            self.loadDetails(forItemsAtPage: page) {
                completion(.success(self.repositories.items(inPage: page, pageSize: self.pageSize).toArray()))
            }
            return
        }
        
        RepositoriesService.getRepositories { res in
            switch res {
            case .success(let data):
                self.repositories = data
                self.loadDetails(forItemsAtPage: page) {
                    completion(.success(self.repositories.items(inPage: page, pageSize: self.pageSize).toArray()))
                }
//                self.loadedPages.insert(page)
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func fetchRepos(withName name: String, page: Int, completion: @escaping (Result<[Repository], Error>)-> Void) {
        
        if repositories.isEmpty {
            fetchRepos(page: 1) { res in
                switch res {
                case .success(_):
                    self.filteredRepos = self.search(forReposWithName: name)
                    completion(.success(self.filteredRepos.items(inPage: page, pageSize: self.pageSize).toArray()))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if name != self.searchKeyword {
                self.filteredRepos = self.search(forReposWithName: name)
            }
            var items = self.filteredRepos.items(inPage: page, pageSize: self.pageSize).toArray()
            items.loadDetails()
            completion(.success(items))
            self.searchKeyword = name
        }
        
    }
    
    private func search(forReposWithName name: String)-> [Repository] {
        self.repositories.filter{ $0.name?.lowercased().contains(name.lowercased()) ?? false }
    }
    
    func clearCache() {
        repositories = []
        filteredRepos = []
//        loadedPages.removeAll()
    }
    
    private func loadDetails(forItemsAtPage page: Int, completion: @escaping()-> Void) {
        DispatchQueue.global(qos: .background).async {
            var items = self.repositories.items(inPage: page, pageSize: self.pageSize)
            #warning("load details")
//            items.loadDetails()
            completion()
        }
    }
    
    private func loadDetails(forItemAtIndex index: Int) {
        if repositories[index].createdAt != nil { return }
        print(index)
        guard let urlString = repositories[index].url, let url = URL(string: urlString) else {return}
        guard let data = try? Data(contentsOf: url),
              let dict = try? JSONHelper.shared.dictionary(fromData: data) else { return }
        
        let creationDate = dict["created_at"] as? String ?? ""
        let language = dict["language"] as? String
        let formattedDate = formattedStringDate(fromString: creationDate)
        
        DispatchQueue.global(qos: .background).sync(flags: .barrier) {
            repositories[index].createdAt = formattedDate
            repositories[index].language = language
        }
    }
    
    private func formattedStringDate(fromString dateString: String)-> String {
        let currentDateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let desiredDateFormat = "dd/MM/yy"
        return DateHelper.shared.changeDateFormat(date: dateString, sentDateFormat: currentDateFormat,
                                                               desiredFormat: desiredDateFormat)
    }
    
}



