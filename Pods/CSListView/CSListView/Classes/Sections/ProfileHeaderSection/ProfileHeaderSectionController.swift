//
//  ProfileHeaderSectionController.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListSwiftKit
import IGListKit

final public class ProfileHeadSectionController: ListSectionController {
    
    private var object: ProfileHeaderViewModel!
    
    public override func numberOfItems() -> Int {
        return object.count
    }
    
    public override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 0
        let labelsHeight: CGFloat = 22 + 18
        switch index {
        case 0:
            height = 94 + 17 + 48 + 16 + 18
        case 1:
            if object?.hasBio == true {
                height = ProfileHeaderBioCell.bioHeight(bio: object?.bio ?? "", width: collectionContext.containerSize.width) + 12
            } else if object?.hasLabels == true {
                height = labelsHeight
            }
        case 2:
            height = labelsHeight
        default:
            break
        }
        return CGSize(width: collectionContext.containerSize.width, height: height)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        switch index {
        case 0:
            let cell: ProfileHeaderInfoCell = collectionContext.dequeueReusableCell(for: self, at: index)
            cell.nameLabel.text = object?.name
            cell.onlineView.isHidden = !object.online
            cell.subTitleLabel.text = object.subName
            cell.avatarImagView.updateAvatar(object.avatar)
            return cell
        case 1:
            if object?.hasBio == true {
                let cell: ProfileHeaderBioCell = collectionContext.dequeueReusableCell(for: self, at: index)
                cell.bioLabel.text = object.bio
                return cell
            }
        default:
            break
        }
        let cell: ProfileHeaderLabelsCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.update(labels: object.labels)
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? ProfileHeaderViewModel
    }
}
