//
//  ListUserModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/25.
//

import ObjectMapper
import CSCommon

public enum RelationStatus: String {
    case normal
    case good
    case close
    case none

}

class UserList: Mappable  {
    var more: [CommonUserModel] = []
    var suggested: [CommonUserModel] = []
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        more   <- map["more"]
        suggested   <- map["suggested"]

    }

}

class ConnectRequestList: Mappable  {
    var users: [RequestUserModel] = []
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        users   <- map["user_list"]
    }

}

struct RequestUserModel: Mappable {
    
    var id: UInt = 0
    var name: String = ""
    var thumbnailUrl: String?
    var userStatus: String?
    var online: Bool = false
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id     <- map["id"]
        name   <- map["name"]
        thumbnailUrl   <- map["user_thumbnail"]
        
        userStatus   <- map["user_status"]
        
        
        online   <- map["is_online"]
        
        
    }
    
    var avatar: String {
        return thumbnailUrl ?? ""
    }
    var subTitle: String? {
        return userStatus
    }
}

//extension RequestUserModel: FriendItemDisplay {
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
//        return .enable("Accept")
//    }
//    
//    var right1Action: FriendItemRightStyle {
//        return .enableDark("Decline")
//    }
//
//}
