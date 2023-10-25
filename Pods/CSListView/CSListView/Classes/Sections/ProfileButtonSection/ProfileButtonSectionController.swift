//
//  ProfileButtonSectionController.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListSwiftKit
import IGListKit

public protocol ProfileButtonSectionControllerDelegate: AnyObject {
    func profileButtonSectionControllerDidTapButton(_ sectionController: ProfileButtonSectionController)
}

final public class ProfileButtonSectionController: ListSectionController {
    
    private var object: ProfileButtonViewModel!
    public weak var delegate: ProfileButtonSectionControllerDelegate?

    public override init() {
        super.init()
        inset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
    }
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 50)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: ProfileButtonCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.fieldBtn.isEnabled = object.enable
        if object.enable {
            cell.fieldBtn.setTitle(object.title, for: .normal)
            cell.fieldBtn.setImage(object.image, for: .normal)
        } else {
            cell.fieldBtn.setTitle(object.title, for: .disabled)
            cell.fieldBtn.setImage(object.image, for: .disabled)
        }
        cell.delegate = self
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? ProfileButtonViewModel
    }
}

extension ProfileButtonSectionController: ProfileButtonCellDelegate {
    func profileButtonCellDidTapButton(_ cell: ProfileButtonCell) {
        delegate?.profileButtonSectionControllerDidTapButton(self)
    }
}
