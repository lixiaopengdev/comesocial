//
//  TimeDewViewModel.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListKit



final public class TimeDewViewModel {
    public let id: UInt
    public var type: String?
    public var icon: String?
    public var title: String?
    public var timeStamp: Int64?
    public var content: String?
    public var imageContent: String?
    public var reactions: [TimeDewReactionCellModel]?
    public var isSave: Bool?
    public var fieldID: UInt?
    public var onwerID: String?
    public var members: [Int]?
    public var members_thumbs:[String]?
    
    public init(id: UInt, type: String? = nil, icon: String? = nil, title: String? = nil, timeStamp: Int64? = nil, content: String? = nil, imageContent: String? = nil, reactions: [TimeDewReactionCellModel]? = nil, isSave: Bool? = nil, fieldID: UInt? = nil, onwerID: String? = nil, members: [Int]? = nil, members_thumbs: [String]? = nil) {
        self.id = id
        self.type = type
        self.icon = icon
        self.title = title
        self.timeStamp = timeStamp
        self.content = content
        self.imageContent = imageContent
        self.reactions = reactions
        self.isSave = isSave
        self.fieldID = fieldID
        self.onwerID = onwerID
        self.members = members
        self.members_thumbs = members_thumbs
    }
    
    
    public func deleteReaction(label: String, onwer: String) -> Bool {
        guard let reactions = reactions else {return false}
        guard let reaction = reactions.first(where: {$0.reactionLabel == label}) else {return false}
        guard let index = reaction.reactionUsers.firstIndex(where: {$0 == onwer}) else {return false}
        reaction.reactionUsers.remove(at: index)
        return true
    }
    
    public func hasReaction(label: String, onwer: String) -> Bool {
        guard let reactions = reactions else {return false}
        guard let reaction = reactions.first(where: {$0.reactionLabel == label}) else {return false}
        return reaction.reactionUsers.contains(where: {$0 == onwer})
    }
    
    public func addReaction(label: String, onwer: String) -> Bool {
        guard let reactions = reactions else {
            let reactions = [TimeDewReactionCellModel(reactionLabel: label, reactionUsers: [onwer])]
            self.reactions = reactions
            return true
        }

        guard let reactionIndex = reactions.firstIndex(where: {$0.reactionLabel == label}) else {
            self.reactions!.append(TimeDewReactionCellModel(reactionLabel: label, reactionUsers: [onwer]))
            return true
        }

        if let reactionUserIndex = reactions[reactionIndex].reactionUsers.firstIndex(of: onwer) {
            return false
        }else{
            self.reactions![reactionIndex].reactionUsers.insert(onwer, at: 0)
            return true
        }
    }
    
}

extension TimeDewViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TimeDewViewModel else { return false }
        return id == object.id && icon == object.icon && title == object.title && reactions == object.reactions
    }
    
}
