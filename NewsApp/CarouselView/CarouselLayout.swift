//
//  CarouselLayout.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit


class CarouselLayout: UICollectionViewLayout {

    private var itemsAttributes: [UICollectionViewLayoutAttributes] = []
    private var itemSize: CGSize!
    private var spacing: CGFloat!
    private var edgeOffsetX: CGFloat = 15
    private var focusedItemIndex: Int = 0
    
    override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView else { return }
        
        itemSize = CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        spacing = itemSize.width * 0.14
        
        collectionView.contentInset.left = (collectionView.bounds.size.width - itemSize.width) / 2
        collectionView.contentInset.right = (collectionView.bounds.size.width - itemSize.width) / 2
        
        resetAttributes()
    }
    
    private func resetAttributes() {
        
        guard let collectionView = collectionView else { return }
        itemsAttributes.removeAll()
        
        for itemIndex in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: itemIndex, section: 0))
            attributes.frame.size = itemSize
            attributes.frame.origin.y = 0
            attributes.frame.origin.x = edgeOffsetX + itemSize.width/2 - collectionView.frame.width/2 + CGFloat(itemIndex) * (itemSize.width + spacing)
            itemsAttributes.append(attributes)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let xMin = itemsAttributes.first?.frame.minX ?? 0
        let xMax = itemsAttributes.last?.frame.maxX ?? 0
        return CGSize(width: xMax - xMin, height: itemSize.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemsAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true // to recalculate at every scroll
    }
}