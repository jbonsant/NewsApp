//
//  CarouselView.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

class CarouselView: View, UICollectionViewDataSource {
    
    private var articles: [NewsArticle] = []
    private var images: [UIImage?] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = CarouselLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reusableIndentifer)
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func postInit() {
        super.postInit()
        backgroundColor = .red
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func updateContent(articles: [NewsArticle]) {
        self.articles = articles
        
        self.images = Array<UIImage?>(repeating: nil, count: articles.count)
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reusableIndentifer, for: indexPath) as! CarouselCell
            
        if let image = images[indexPath.row] {
            cell.imageView.image = image // Take cached image
        } else if let imageUrl = URL(string: articles[indexPath.row].urlToImage ?? "") {
            UIImage.download(url: imageUrl) { [weak self] (image) in // Download image
                self?.images[indexPath.row] = image
                if let image = image {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        } else {
            cell.imageView.image = nil
        }
        
        return cell
    }
    
}
