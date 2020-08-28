//
//  ViewController.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

class ViewController: UIViewController, CarouselViewDelegate {
    
    var newsProvider: NewsProvider!
    var newsArticles: [NewsArticle] = []
    
    lazy var carouselView: CarouselView = {
        var view = CarouselView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.addSubview(carouselView)
        
        NSLayoutConstraint.activate([
            carouselView.leftAnchor.constraint(equalTo: view.leftAnchor),
            carouselView.rightAnchor.constraint(equalTo: view.rightAnchor),
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            carouselView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
        
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
                self.newsArticles = articles
                self.carouselView.updateContent(articles: articles)
            case .failure(let error):
                print("News fetch failed. error = '\(error.localizedDescription)'")
            }
        }
    }
    
    //MARK: CarouselViewDelegate
    func carouselViewFocusedItemWillChangeTo(index: Int) {
        guard !newsArticles.isEmpty else { return }
        let article = newsArticles[index]
        print(article.title ?? "nil")
    }
}

