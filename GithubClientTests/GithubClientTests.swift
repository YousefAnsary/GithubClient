//
//  GithubClientTests.swift
//  GithubClientTests
//
//  Created by Yousef on 4/7/21.
//

import XCTest
@testable import GithubClient

class GithubClientTests: XCTestCase {

//    override func setUpWithError() throws {
//
//    }
//
//    override func tearDownWithError() throws {
//
//    }

    func testLocalFetch() throws {
        let expectation = self.expectation(description: "Waititng Response")
        RepositoriesService.getRepositories(locally: true) { res in
            switch res {
            case .success(let repos):
                XCTAssert(repos.count > 0)
                expectation.fulfill()
            case .failure(let err):
                XCTFail(String(describing: err))
            }
        }
        waitForExpectations(timeout: 40)
    }

    func testRemoteFetch() throws {
        let expectation = self.expectation(description: "Waititng Response")
        RepositoriesService.getRepositories(locally: false) { res in
            switch res {
            case .success(let repos):
                XCTAssert(repos.count > 0)
                var repos = repos.items(inPage: 1, pageSize: 10)
                repos.loadDetails()
                XCTAssertNotNil(repos.first?.createdAt)
                XCTAssertNotNil(repos.last?.createdAt)
                expectation.fulfill()
            case .failure(let err):
                XCTFail(String(describing: err))
            }
        }
        waitForExpectations(timeout: 40)
    }
    
}
