//
//  RepositoriesRepository.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class RepositoriesRepository {
    
    private var repositories = [Repository]()
    private var loadedPages = Set<Int>()
    
    func loadRemotely(page: Int, completion: @escaping(Result<[Repository], Error>)-> Void) {
        
        if loadedPages.contains(page) {
            self.loadDetails(forItemsAtPage: page) {
                completion(.success(Array(self.repositories[self.range(forPage: page)])))
            }
            return
        }
        
        RepositoriesService.getRepositories { res in
            switch res {
            case .success(let data):
                self.repositories = data
                self.loadDetails(forItemsAtPage: page) {
                    completion(.success(Array(self.repositories[self.range(forPage: page)])))
                }
                self.loadedPages.insert(page)
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func clearCache() {
        loadedPages.removeAll()
    }
    
    private func loadDetails(forItemsAtPage page: Int, completion: @escaping()-> Void) {
        DispatchQueue.global(qos: .background).async {
            for i in self.range(forPage: page){
                self.loadDetails(forItemAtIndex: i)
            }
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
    
    private func range(forPage page: Int)-> ClosedRange<Int> {
        ((page - 1) * 10) ... min(self.repositories.count, page * 10)
    }
    
    private func formattedStringDate(fromString dateString: String)-> String {
        let currentDateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let desiredDateFormat = "dd/MM/yy"
        return DateHelper.shared.changeDateFormat(date: dateString, sentDateFormat: currentDateFormat,
                                                               desiredFormat: desiredDateFormat)
    }
    
}
