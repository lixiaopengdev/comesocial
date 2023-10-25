//
//  ProfileButtonViewModel.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListKit

final public class ProfileButtonViewModel {
    let title: String
    let image: UIImage?
    let enable: Bool
    
    public init(title: String, image: UIImage?, enable: Bool) {
        self.title = title
        self.image = image
        self.enable = enable
    }
}

extension ProfileButtonViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? ProfileButtonViewModel else { return false }
        return image == object.image && enable == object.enable
    }
}
