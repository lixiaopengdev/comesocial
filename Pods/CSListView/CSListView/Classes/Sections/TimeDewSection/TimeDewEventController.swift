//
//  TimeDewEventController.swift
//  CSListView
//
//  Created by fuhao on 2023/6/19.
//

import Foundation
import IGListSwiftKit
import IGListKit

final public class TimeDewEventController: ListSectionController {
    
    private var object: TimeDewViewModel!
    
    public override func numberOfItems() -> Int {
        return 1
    }
    
    public override func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let avatarImageCount = (object.members?.count ?? 0) + 1
        let height = TimeDewEventCell.forHeight(width: width, avatarImageCount: avatarImageCount, content: object.content ?? "")
        return CGSize(width: collectionContext.containerSize.width, height: height)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell:TimeDewEventCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.delegate = self
        cell.bindViewModel(object as Any)
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? TimeDewViewModel
    }
}

extension TimeDewEventController : TimeDewEventCellDelegate {
    func didEvent(cell: TimeDewEventCell) {
        
    }
}
