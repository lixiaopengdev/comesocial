//
//  TitleSectionController.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListSwiftKit
import IGListKit

final public class TitleSectionController: ListSectionController {
    
    private var object: String!
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 57)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: TitleCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.titleLabel.text = object
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? String
    }
}

