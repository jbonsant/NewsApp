//
//  ViewController.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

extension UIColor {
    static let header = UIColor.white
    static let newsLabel = UIColor(red: 0.997, green: 0.575, blue: 0.003, alpha: 1.00)
}

class ViewController: UIViewController, CarouselViewDelegate {
    
    var newsProvider: NewsProvider!
    var newsArticles: [NewsArticle] = []
    
    lazy var headerTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Parutions récentes"
        label.font = UIFont.systemFont(ofSize: 26, weight: .black)
        label.textColor = .header
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sourceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .newsLabel
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .newsLabel
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .newsLabel
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var carouselView: CarouselView = {
        var view = CarouselView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.addSubview(headerTitleLabel)
        view.addSubview(carouselView)
        view.addSubview(sourceLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            carouselView.leftAnchor.constraint(equalTo: view.leftAnchor),
            carouselView.rightAnchor.constraint(equalTo: view.rightAnchor),
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            carouselView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            headerTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            headerTitleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            headerTitleLabel.bottomAnchor.constraint(equalTo: carouselView.topAnchor),
            
            sourceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22),
            sourceLabel.topAnchor.constraint(equalTo: carouselView.topAnchor, constant: 7),
            
            titleLabel.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
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
                self.carouselViewFocusedItemWillChangeTo(index: 0)
            case .failure(let error):
                print("News fetch failed. error = '\(error.localizedDescription)'")
            }
        }
    }
    
    //MARK: CarouselViewDelegate
    func carouselViewFocusedItemWillChangeTo(index: Int) {
        guard !newsArticles.isEmpty else { return }
        let article = newsArticles[index]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.sourceLabel.text = article.source?.name ?? ""
            self.titleLabel.text = article.title ?? ""
            self.descriptionLabel.text = article.description ?? ""
        }
    }
}

