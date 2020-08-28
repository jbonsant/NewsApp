//
//  Models.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import Foundation

struct ApiResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

struct NewsArticle: Decodable {
    let source: NewsArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct NewsArticleSource: Decodable {
    let id: String?
    let name: String?
}
