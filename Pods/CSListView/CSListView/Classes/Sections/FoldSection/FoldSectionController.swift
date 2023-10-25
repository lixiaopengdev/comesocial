//
//  FoldSectionController.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListSwiftKit
import IGListKit

public protocol FoldSectionControllerDelegate: AnyObject {
    func foldSectionControllerDidTapRightArea(_ cell: FoldSectionController)
    func foldSectionControllerDidTapleftArea(_ cell: FoldSectionController, fold: Bool)
}

final public class FoldSectionController: ListSectionController {
   
    public weak var delegate: FoldSectionControllerDelegate?
    
    private var object: FoldViewModel!
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 38)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: FoldCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.titleLabel.text = object.leftTitle
        cell.rightLabel.attributedText = object.rightAttributedTitle
        cell.arrowImageView.isHidden = object.fold == nil
        if let fold = object.fold {
            cell.arrowImageView.transform = CGAffineTransform(rotationAngle: fold ? CGFloat.pi : 0)
        }
        cell.delegate = self
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? FoldViewModel
    }
}

extension FoldSectionController: FoldCellDelegate {
    func foldCellDidTapRightArea(_ cell: FoldCell) {
        delegate?.foldSectionControllerDidTapRightArea(self)
    }
    
    func foldCellDidTapleftArea(_ cell: FoldCell) {
        object.fold = !(object.fold ?? false)
        if let fold = object.fold {
            UIView.animate(withDuration: 0.3) {
                cell.arrowImageView.transform = CGAffineTransform(rotationAngle: fold ? CGFloat.pi : 0)
            }
        }
        delegate?.foldSectionControllerDidTapleftArea(self, fold: object.fold ?? false)
    }
    
    
}

