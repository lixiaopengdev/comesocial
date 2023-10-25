//
//  UserSectionController.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListSwiftKit
import IGListKit
import CSMediator
import CSUtilities

public protocol UserSectionControllerDelegate: AnyObject {
    func userSectionControllerDidTapRightButton(_ sectionController: UserSectionController)
    func userSectionControllerDidTapleftButton(_ sectionController: UserSectionController)
}


final public class UserSectionController: ListSectionController {
    
    private var object: UserViewModel!
    
    public weak var delegate: UserSectionControllerDelegate?
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 64)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: UserCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.nameLabel.text = object.name
        cell.fieldLabel.text = object.subTitle
        cell.onlineView.isHidden = !object.online
        cell.relationIcon.isHidden = object.relationIcon == nil
        cell.relationIcon.text = object.relationIcon
        cell.avatarImageView.setAvatar(with: object.avatar)
        updateRight(button: cell.rightButton, action: object.rightAction)
        updateRight(button: cell.leftButton, action: object.leftAction)
        cell.delegate = self
        return cell
    }
    
    private func updateRight(button: LoaderButton, action: UserViewModel.ActionStyle) {
        button.isLoading = false
        switch action {
        case .hide:
            button.isHidden = true
        case .enable(let text, _):
            button.isHidden = false
            button.isEnabled = true
            button.setTitle(text, for: .normal)
            button.setTitleColor(.cs_primaryPink, for: .normal)
            
        case .disable(let text):
            button.isHidden = false
            button.isEnabled = false
            button.setTitle(text, for: .disabled)
            button.setTitleColor(.cs_primaryPink, for: .normal)
        case .enableDark(let text, _):
            button.isHidden = false
            button.isEnabled = true
            button.setTitle(text, for: .normal)
            button.setTitleColor(.cs_lightGrey, for: .normal)
        }
    }
    
    
    public override func didUpdate(to object: Any) {
        self.object = object as? UserViewModel
    }
    
    public override func didSelectItem(at index: Int) {
//        Router.shared.push(Router.Me.profilePath(uid: object.id))
        if let vc = Mediator.resolve(MeService.ViewControllerService.self)?.profileViewController(uid: object.id) {
            Mediator.push(vc)
        }
    }
}


extension UserSectionController: UserCellDelegate {
    func userCellDidTapRightButton(_ cell: UserCell) {
        delegate?.userSectionControllerDidTapRightButton(self)
    }
    
    func userCellDidTapleftButton(_ cell: UserCell) {
        delegate?.userSectionControllerDidTapleftButton(self)

    }
    
    
}
