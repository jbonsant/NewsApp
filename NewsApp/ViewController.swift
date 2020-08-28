//
//  ViewController.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

class ViewController: UIViewController {
    
    var newsProvider: NewsProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews()
    }
    
    init(newsProvider: NewsProvider) {
        self.newsProvider = newsProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchNews() {
        
        newsProvider.requestNews { result in
            switch result {
            case .success(let articles):
                print("\(articles.count) articles found")
            case .failure(let error):
                print("News fetch failed. error = '\(error.localizedDescription)'")
            }
        }
    }


}

