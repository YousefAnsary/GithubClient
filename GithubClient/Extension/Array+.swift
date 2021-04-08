//
//  Array+.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import Foundation

extension Array {
    
    func range(inPage page: Int, pageSize: Int)-> ClosedRange<Int> {
        let upperBound = Swift.min(self.count - 1, page * pageSize)
        let lowerBound = ((page - 1) * pageSize)
        guard count > 0, upperBound >= lowerBound else { return 0 ... 0 }
        return ((page - 1) * pageSize) ... Swift.min(self.count - 1, page * pageSize)
    }
    
    func items(inPage page: Int, pageSize: Int)-> ArraySlice<Element> {
        if count == 0 {return []}
        return self[range(inPage: page, pageSize: pageSize)]
    }
    
}
