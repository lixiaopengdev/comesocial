//
//  TimeDewReactionCellModel.swift
//  CSListView
//
//  Created by fuhao on 2023/6/19.
//

import Foundation
import IGListSwiftKit
import IGListKit


public final class TimeDewReactionCellModel: TimeDewBaseCellModel,ListDiffable,Equatable {
    public static func == (lhs: TimeDewReactionCellModel, rhs: TimeDewReactionCellModel) -> Bool {
        return lhs.reactionLabel == rhs.reactionLabel && lhs.reactionUsers == rhs.reactionUsers
    }
    
    public let reactionLabel: String
    public var reactionUsers: [String]

    public init(reactionLabel: String, reactionUsers: [String]) {
        self.reactionLabel = reactionLabel
        self.reactionUsers = reactionUsers
    }

    public func diffIdentifier() -> NSObjectProtocol {
        return reactionLabel as NSObjectProtocol
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object {
            return true
        }
        guard let object = object as? TimeDewReactionCellModel else  { return false }
        return reactionLabel == object.reactionLabel && reactionUsers == object.reactionUsers && isBottom == object.isBottom
    }
}
