//
//  SwitchSectionController.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListSwiftKit
import IGListKit

public protocol SwitchSectionControllerDelegate: AnyObject {
    func switchSectionControllerDidValueChanged(_ sectionController: SwitchSectionController, value: Bool)
}

final public class SwitchSectionController: ListSectionController {
    
    private var object: SwitchViewModel!
    public weak var delegate: SwitchSectionControllerDelegate?
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 74)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: SwitchCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.titleLabel.text = object.title
        cell.subTitleLabel.text = object.subTitle
        cell.switchBtn.isOn = object.isOpen
        cell.delegate = self
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? SwitchViewModel
    }
}

extension SwitchSectionController: SwitchCellDelegate {
    func switchCellDidValueChanged(_ cell: SwitchCell) {
        object.isOpen = cell.switchBtn.isOn
        cell.subTitleLabel.text = object.subTitle
        delegate?.switchSectionControllerDidValueChanged(self, value: cell.switchBtn.isOn)
    }

}
 
