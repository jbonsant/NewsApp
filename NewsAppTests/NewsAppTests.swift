//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import XCTest
@testable import NewsApp

class NewsAppTests: XCTestCase {
    
    class FakeNewsAPI: NewsProvider {
        
        let resource: String!
        
        init(resource: String) {
            self.resource = resource
        }
        
        func requestNews(completionHandler: @escaping (Result<[NewsArticle], NewsProviderError>) -> Void) {
            let path = Bundle(for: type(of: self)).path(forResource: resource, ofType: "json")!
            let json = try! String(contentsOfFile: path, encoding: .utf8)
            let data = json.data(using: .utf8)!
            do {
                let response = try JSONDecoder().decode(ApiResponse.self, from: data)
                completionHandler(.success(response.articles))
            } catch {
                completionHandler(.failure(.jsonParsingFailed(error)))
            }
        }
    }
    
    func testNewsParsing() throws {
        FakeNewsAPI(resource: "good_response").requestNews { result in
            switch result {
            case .success(let articles):
                XCTAssertEqual(articles.count, 20)
            case .failure(let error):
                XCTFail("Request should not failed. error = \(error.localizedDescription)")
            }
        }
    }
    
    func testNewsParsingOfEmptyResponse() throws {
        FakeNewsAPI(resource: "empty_response").requestNews { result in
            switch result {
            case .success(_):
                XCTFail("Request should failed")
            case .failure(let error):
                switch error {
                case  .jsonParsingFailed(_):
                    break
                default:
                    XCTFail("Only JSON parsing should be failing. error = '\(error)'")
                }
            }
        }
    }
    
    func testViewControllerNewsFetch() throws {
        let viewController = ViewController(newsProvider: FakeNewsAPI(resource: "good_response"))
        viewController.fetchNews()
        XCTAssertEqual(viewController.newsArticles.count, 20)
    }
}
