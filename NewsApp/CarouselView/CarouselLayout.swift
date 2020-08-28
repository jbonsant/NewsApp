//
//  CarouselLayout.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

protocol CarouselLayoutDelegate: AnyObject {
    func carouselLayoutFocusedItemWillChangeTo(index: Int)
}

class CarouselLayout: UICollectionViewLayout {

    weak var delegate: CarouselLayoutDelegate?
    
    private var itemsAttributes: [UICollectionViewLayoutAttributes] = []
    private var itemSize: CGSize!
    private var spacing: CGFloat!
    private var edgeOffsetX: CGFloat = 15
    private var focusedItemTargetCenterX: CGFloat!
    
    private var focusedItemIndex: Int = 0
    
    override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView else { return }
        
        itemSize = CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        spacing = itemSize.width * 0.14
        focusedItemTargetCenterX = (itemSize.width / 2) + edgeOffsetX
        
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
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var nextFocusedItemIndex = indexForOffset(proposedContentOffset.x)
        
        if nextFocusedItemIndex == focusedItemIndex { // Prevent instant "snap back" when there is residual scrolling velocity
            if velocity.x < 0 && nextFocusedItemIndex != 0 {
                nextFocusedItemIndex -= 1
            } else if velocity.x > 0 && nextFocusedItemIndex != itemsAttributes.count - 1 {
                nextFocusedItemIndex += 1
            }
        }
        
        if focusedItemIndex != nextFocusedItemIndex {
            focusedItemIndex = nextFocusedItemIndex
            delegate?.carouselLayoutFocusedItemWillChangeTo(index: nextFocusedItemIndex)
        }
  
        return offsetForItemAtIndex(nextFocusedItemIndex)
    }
    
    private func indexForOffset(_ xOffset: CGFloat) -> Int {
        let itemSpace = itemSize.width + spacing
        return Int(round(xOffset / itemSpace) + 1)
    }
    
    private func offsetForItemAtIndex(_ index: Int) -> CGPoint {
        let xOffset = itemsAttributes[index].center.x - focusedItemTargetCenterX
        return CGPoint(x: xOffset, y: 0)
    }
}
