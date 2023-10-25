//
//  CardStackLayout.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/23.
//

import UIKit

class CardStackLayout: UICollectionViewLayout {

    private let kContentOffset = "contentOffset"
    
    private let cardSize = CGSize(width: 50, height: 70)
    private let sectionHorizontalInset = 20.0
    private let interitemSpacing = 17.0
    
    private var contentBounds = CGRect.zero
    private(set) var fold = false;
    private var foldingScrolling = false
    private var hasObserve = false
    private var targetOffset: CGFloat = 0

    private var attributesArray = [CardStackCollectionViewLayoutAttributes]()
    
    func isFullScreenItem(at indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 { return true }
        if let frame = layoutAttributesForItem(at: indexPath)?.frame,
           let preFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.row - 1, section: 0))?.frame {
            return frame.minX > preFrame.maxX
        }
        return true
    }
    
    func foldItems() {
        guard let collectionView = collectionView else { return }
        collectionView.isScrollEnabled = false
        targetOffset = -(collectionView.bounds.width - sectionHorizontalInset)
        
        if abs(collectionView.contentOffset.x - targetOffset) < 2 {
            doFoldItems()
        } else {
            foldingScrolling = true
            collectionView.setContentOffset(CGPoint(x: targetOffset, y: 0), animated: true)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let contentOffsetX = (change?[NSKeyValueChangeKey.newKey] as? CGPoint)?.x ?? -1
            
            if abs(contentOffsetX - targetOffset) < 2 && foldingScrolling {
                doFoldItems()
            }
            if contentOffsetX < -50 && !foldingScrolling {
                foldItems()
            }
        }
    }
    
    func doFoldItems() {
        guard let collectionView = collectionView else { return }
        collectionView.isScrollEnabled = false
        collectionView.performBatchUpdates {
            self.fold = true
            self.invalidateLayout()
        } completion: { _ in
            self.foldingScrolling = false
        }
    }
    

    
    
    func unfoldItems() {
        guard let collectionView = collectionView else { return }
//        UIView.animate(withDuration: 3) {
            collectionView.performBatchUpdates {
                self.fold = false
                self.invalidateLayout()
            } completion: { _ in
                collectionView.isScrollEnabled = true
            }
//        }

    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        attributesArray.removeAll(keepingCapacity: true)
        if (!hasObserve) {
            hasObserve = true
            collectionView.addObserver(self, forKeyPath: kContentOffset, options: [.new, .old], context: nil)
        }
        let count = collectionView.numberOfItems(inSection: 0)
        let distance = cardSize.width + interitemSpacing
        let width: CGFloat =  max(Double(count + 1) * distance + sectionHorizontalInset * 2, collectionView.bounds.width)
        let contentRect = CGRect(x: 0, y: 0, width:width, height: cardSize.height)
        contentBounds = contentRect
        
    }

    override var collectionViewContentSize: CGSize {
        return contentBounds.size

    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        if fold {
            return foldLayoutAttributesForElements(in: rect)
        } else {
            return unfoldLayoutAttributesForElements(in: rect)
        }
            
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 数据量很小，便利就行
       return attributesArray.first(where: { $0.indexPath == indexPath} )
    }
    
     func foldLayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         guard let collectionView = collectionView else { return nil}
         let count = collectionView.numberOfItems(inSection: 0)
         let rightMarigin = collectionView.bounds.maxX - 20 - 50
//         var attributesArray = [CardStackCollectionViewLayoutAttributes]()
         for index in 0..<count {
             let attributes = CardStackCollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
             attributes.frame = CGRect(x: rightMarigin, y: 0, width: 50, height: 70)
             attributes.zIndex = count - index + 100
             var transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
             attributes.fold = true
             var transformIndex = index
             if (index >= 4) {
                 attributes.contentHidden = true
                 transformIndex = 4
             }
             transform = transform.rotated(by: (5 * CGFloat(transformIndex) / 180) * CGFloat.pi)
             attributes.transform = transform
//             print(transform)

             attributesArray.append(attributes)
         }

         return attributesArray
         
     }
    

    
    func unfoldLayoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil}
        
//        var attributesArray = [CardStackCollectionViewLayoutAttributes]()

        let distance = cardSize.width + interitemSpacing
        let count = collectionView.numberOfItems(inSection: 0)
        let offsetRight = collectionView.contentOffset.x + collectionView.bounds.width
        
        for row in 0 ..< count {
            let lerp = (offsetRight - Double(row) * distance - sectionHorizontalInset) / distance
            let cardOffset = fixdX(input: lerp) * distance
            let itemX = collectionView.bounds.width - sectionHorizontalInset - cardSize.width - cardOffset + collectionView.contentOffset.x
            let attributes = CardStackCollectionViewLayoutAttributes(forCellWith: IndexPath(item: row, section: 0))
            attributes.frame = CGRect(origin: CGPoint(x: itemX, y: 0), size: cardSize)
            attributes.zIndex = count - row
            attributesArray.append(attributes)
        }
//        print(attributesArray.count)
        return attributesArray

    }

    func fixdX(input: CGFloat) -> CGFloat{
        var out: CGFloat = 0
        if input < 0 {
            out = 0
        } else if input < 2 {
            out = pow(input, 2) / 4
        } else {
            out = input - 1
        }
        return out
    }


    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    deinit {
        
        if hasObserve {
            collectionView?.removeObserver(self, forKeyPath: kContentOffset)
        }
        
    }
}



