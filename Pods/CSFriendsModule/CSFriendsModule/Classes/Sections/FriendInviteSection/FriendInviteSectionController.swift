//
//  FriendInviteSectionController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

import IGListSwiftKit
import IGListKit
import CSUtilities

final public class FriendInviteSectionController: ListSectionController, FriendInviteCellDelegate {
 
    private var object: String!
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 128)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: FriendInviteCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.delegate = self
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? String
    }
    
    func friendInviteCellDidTapLinkButton(_ cell: FriendInviteCell) {
        UIPasteboard.general.string = object
        HUD.showMessage("The link has been copied to the clipboard.")
    }
    
    func friendInviteCellDidTapDiscoardButton(_ cell: FriendInviteCell) {
        
    }
    
    func friendInviteCellDidTapMessageButton(_ cell: FriendInviteCell) {
        
    }
}


