//
//  NoticeItemDisplay.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/12.
//

import IGListKit

final public class NoticeViewModel {
    
    public var avatars: [String]
    public let content: String
    
    public init(content: String, avatars: [String]) {
        self.avatars = avatars
        self.content = content
    }
}

extension NoticeViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return content as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? NoticeViewModel else { return false }
        return avatars == object.avatars
    }
}
