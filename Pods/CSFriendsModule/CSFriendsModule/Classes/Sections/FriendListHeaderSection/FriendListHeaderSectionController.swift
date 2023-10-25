//
//  FriendListSectionController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

import IGListSwiftKit
import IGListKit
import CSUtilities

final public class FriendListHeaderSectionController: ListSectionController {
    
    public override func sizeForItem(at index: Int) -> CGSize {
        let width = Device.UI.screenWidth - 24
        let height = 67 / 366 * width
        return CGSize(width: collectionContext.containerSize.width, height: height + 48 + 8)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: FriendListHeaderCell = collectionContext.dequeueReusableCell(for: self, at: index)
        return cell
    }
    
    public override func didSelectItem(at index: Int) {
        viewController?.navigationController?.pushViewController(FriendInviteViewController(), animated: true)
    }
}

