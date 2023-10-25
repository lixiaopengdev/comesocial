//
//  FriendSearchSectionController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

import IGListSwiftKit
import IGListKit

public protocol SearchSectionControllerDelegate: AnyObject {
    func searchSectionControllerTextDidChange(_ sectionController: ListSectionController, searchText: String)
}

final public class SearchSectionController: ListSectionController {
    
    public weak var delegate: SearchSectionControllerDelegate?
    
    public override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 40)
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: SearchCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.searchBar.delegate = self
        return cell
    }
    
}

extension SearchSectionController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchSectionControllerTextDidChange(self, searchText: searchText)
    }
}
