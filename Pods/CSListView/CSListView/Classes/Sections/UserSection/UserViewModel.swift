//
//  UserViewModel.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListKit

final public class UserViewModel {
    
    public enum ActionStyle: Equatable {
        case hide
        case enable(String, url: String?)
        case disable(String)
        case enableDark(String, url: String?)
    }
    
    let identifier: String
    
    public let id: UInt
    var name: String
    var subTitle: String?
    var avatar: String
    var online: Bool
    var relationIcon: String?
    var rightAction: ActionStyle
    var leftAction: ActionStyle
    
    public init(section: String, id: UInt, name: String, subTitle: String?, avatar: String, online: Bool, relationIcon: String?, rightAction: ActionStyle, leftAction: ActionStyle) {
        self.identifier = "\(section)_\(String(id))"
        self.id = id
        self.name = name
        self.subTitle = subTitle
        self.avatar = avatar
        self.online = online
        self.relationIcon = relationIcon
        self.rightAction = rightAction
        self.leftAction = leftAction
    }
    
    public var rightActionUrl: String? {
        switch rightAction {
        case .enable(_, url: let url):
            return url
        case .enableDark(_, url: let url):
           return url
        default:
            return nil
        }
    }
}

extension UserViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? UserViewModel else { return false }
        return name == object.name
        && subTitle == object.subTitle
        && avatar == object.avatar
        && online == object.online
        && relationIcon == object.relationIcon
        && rightAction == object.rightAction
        && leftAction == object.leftAction
    }
}
