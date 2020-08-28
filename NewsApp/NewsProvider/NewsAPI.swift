//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import Foundation

class NewsAPI: NewsProvider {
    
    private let Url = "http://newsapi.org/v2/everything"
    private let TopicParam = "bitcoin"
    private let FromParam = "2020-08-28"
    private let SortByParam = "publishedAt"
    
    private let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    private var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func requestNews(completionHandler: @escaping (Result<[NewsArticle], NewsProviderError>) -> Void) {
        
        var url = URL(string: Url)!
       
        url = url.appendingQueryParameters([
            "q":        TopicParam,
            "from":     FromParam,
            "sortBy":   SortByParam,
            "apiKey":   apiKey,
        ])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard error == nil else {
                completionHandler(.failure(.requestFailed(error!)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                completionHandler(.success(apiResponse.articles))
            } catch {
                completionHandler(.failure(.jsonParsingFailed(error)))
            }
        })
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
