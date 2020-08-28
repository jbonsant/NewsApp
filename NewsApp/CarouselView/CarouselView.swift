//
//  CarouselView.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

protocol CarouselViewDelegate: AnyObject {
    func carouselViewFocusedItemWillChangeTo(index: Int)
}

class CarouselView: View, UICollectionViewDelegate, UICollectionViewDataSource, CarouselLayoutDelegate {
    
    weak var delegate: CarouselViewDelegate?
    
    private var articles: [NewsArticle] = []
    private var images: [UIImage?] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = CarouselLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reusableIndentifer)
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func postInit() {
        super.postInit()

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
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        } else {
            cell.imageView.image = nil
        }
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let imageUrl = URL(string: articles[indexPath.row].urlToImage ?? "") else {
            return
        }
        guard images[indexPath.row] == nil else {
            return // already downloaded
        }
     
        UIImage.download(url: imageUrl) { [weak self] (image) in
            self?.images[indexPath.row] = image
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let cell = collectionView.cellForItem(at: indexPath) as? CarouselCell {
                    cell.imageView.image = image // Set image if cell is already displayed
                }
            }
        }
    }
    
    //MARK: CarouselLayoutDelegate
    func carouselLayoutFocusedItemWillChangeTo(index: Int) {
        delegate?.carouselViewFocusedItemWillChangeTo(index: index)
    }
}
