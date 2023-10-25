//
//  SwitchViewModel.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListKit

final public class SwitchViewModel {
    let title: String
    let openSubtitle: String
    let closeSubtitle: String
    var isOpen: Bool
    
    var subTitle: String {
        return isOpen ? openSubtitle : closeSubtitle
    }
  public init(title: String, openSubtitle: String, closeSubtitle: String, isOpen: Bool) {
        self.title = title
        self.openSubtitle = openSubtitle
        self.closeSubtitle = closeSubtitle
        self.isOpen = isOpen
    }
}

extension SwitchViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? SwitchViewModel else { return false }
        return openSubtitle == object.openSubtitle && closeSubtitle == object.closeSubtitle
    }
}
