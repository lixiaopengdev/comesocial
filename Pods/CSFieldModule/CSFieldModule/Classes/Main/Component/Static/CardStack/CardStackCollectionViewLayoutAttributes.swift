//
//  CardStackCollectionViewLayoutAttributes.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/27.
//

import UIKit

class CardStackCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var fold = false
    var contentHidden: Bool = false
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copyObject = super.copy(with: zone) as! CardStackCollectionViewLayoutAttributes
        copyObject.fold = fold
        copyObject.contentHidden = contentHidden
        return copyObject
        
    }

}
