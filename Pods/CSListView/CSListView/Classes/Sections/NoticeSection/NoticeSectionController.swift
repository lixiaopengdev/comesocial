//
//  NoticeSection.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/12.
//

import IGListSwiftKit
import IGListKit
import CSImageKit
import CSMediator

final public class NoticeSectionController: ListSectionController, NoticeCellDelegate {

    private var object: NoticeViewModel?
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 76)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: NoticeCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.contentLabel.text = object?.content
        cell.iconImageView.setAvatar(with: object?.avatars.first)
        cell.delegate = self
        return cell
    }
    
    public override func didUpdate(to object: Any) {
        self.object = object as? NoticeViewModel
    }
    
    func noticeCellDidTapButton(_ cell: NoticeCell) {
        
        if let connectRequestVC = Mediator.resolve(FriendsService.ViewControllerService.self)?.connectRequestViewController() {
            viewController?.navigationController?.pushViewController(connectRequestVC, animated: true)
        }
    }
}
