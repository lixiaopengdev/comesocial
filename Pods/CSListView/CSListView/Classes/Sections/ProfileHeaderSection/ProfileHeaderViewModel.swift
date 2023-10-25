//
//  ProfileHeadViewModel.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListKit
import CSUtilities

final public class ProfileHeaderViewModel {
    public let name: String
    public let online: Bool
    public let avatar: String?
    public let subName: String?
    public let bio: String?
    public let labels: [String]
    
    public init(name: String, online: Bool, avatar: String?, subName: String?, bio: String?, labels: [String]) {
        self.name = name
        self.online = online
        self.avatar = avatar
        self.subName = subName
        self.bio = bio
        self.labels = labels
    }
    var count: Int {
        var count = 1
        if hasBio {
            count += 1
        }
        if hasLabels {
            count += 1
        }
        return count
    }
    
    var hasBio: Bool {
        return !bio.isNilOrEmpty
    }
    
    var hasLabels: Bool {
        return !labels.isEmpty
    }
}

extension ProfileHeaderViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return name as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object
    }
}
