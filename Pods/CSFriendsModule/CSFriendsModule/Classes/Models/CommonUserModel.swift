//
//  CommonUserModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/5.
//

import Foundation
import ObjectMapper
import CSCommon
import CSListView

struct CommonUserModel: Mappable {
    
    var id: UInt = 0
    var name: String = ""
    var thumbnailUrl: String?
    var action: Bool = false
    var actionUrl: String?

    var status: String?
    var userStatus: String?

    var relationStatus: RelationStatus?
    var online: Bool = false

    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id     <- map["id"]
        name   <- map["name"]
        thumbnailUrl   <- map["user_thumbnail"]
        
        status   <- map["status"]
        userStatus   <- map["user_status"]
        action   <- map["can_action"]
        actionUrl   <- map["action_url"]

        online   <- map["is_online"]
        relationStatus   <- (map["curr_type"], EnumTransform())
    }
}

extension CommonUserModel {
    var rightViewModelStyle: UserViewModel.ActionStyle {
        guard let actionTitle = status else { return .hide}
        if actionUrl != nil,
           action {
            return .enable(actionTitle, url: actionUrl)
        } else {
            return .disable(actionTitle)
        }
    }
    var avatar: String {
        return thumbnailUrl ?? ""
    }
    
    var subTitle: String? {
        return userStatus
    }
    var relation: String? {
        return nil
    }
}

//extension CommonUserModel: FriendItemDisplay {
//    var subTitle: String? {
//        return userStatus
//    }
//    
//    var avatar: String {
//        return thumbnailUrl ?? ""
//    }
//    
//    var relation: RelationDisplay? {
//        return RelationDisplay.none
//    }
//    
//    var rightAction: FriendItemRightStyle {
//        guard let actionTitle = status else { return .hide}
//        if actionUrl != nil,
//           action {
//            return .enable(actionTitle)
//        } else {
//            return .disable(actionTitle)
//        }
//    }
//
//}
