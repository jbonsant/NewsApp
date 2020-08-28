//
//  NewsProvider.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import Foundation

enum NewsProviderError: Error {
    case requestFailed(Error)
    case jsonParsingFailed(Error)
    case noData
}

protocol NewsProvider {
    func requestNews(completionHandler: @escaping (Result<[NewsArticle], NewsProviderError>) -> Void)
}
