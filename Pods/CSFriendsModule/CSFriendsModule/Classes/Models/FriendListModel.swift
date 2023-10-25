//
//  FriendListModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/26.
//

import ObjectMapper
import CSCommon

class FriendListModel: Mappable  {
    var all: [FriendUserModel] = []
    var closeFriends: [FriendUserModel] = []
    var friends: [FriendUserModel] = []
    var notices: [FriendNotice] = []
    
    //    var allNum: String = ""
    //    var friendsNums: String = ""
    //    var closeFriendsNums: String = ""
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        all   <- map["all"]
        closeFriends   <- map["close_friends"]
        friends   <- map["friends"]
        notices   <- map["friends_notice.notice_list"]
        //        allNum   <- map["all_nums"]
        //        closeFriendsNums   <- map["close_friends_nums"]
        //        friendsNums   <- map["friends_nums"]
        
    }
    
}

class FriendNotice: Mappable {
    var content: String = ""
    var users: [CommonUserModel] = []
    
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        content   <- map["content"]
        users   <- map["user_list"]
    }
    
    var avatars: [String] {
        return users.map { $0.avatar }
    }
}

//extension FriendNotice: NoticeItemDisplay {
//    var avatar: [String] {
//        return users.map { $0.avatar }
//    }
//    
//    
//}

struct FriendUserModel: Mappable {
    
    var id: UInt = 0
    var name: String = ""
    var thumbnailUrl: String?
    var fieldName: String?
    var relationStatus: RelationStatus?
    var online: Bool = false
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id     <- map["user_id"]
        name   <- map["edges.user.name"]
        thumbnailUrl   <- map["edges.user.thumbnail_url"]
        fieldName   <- map["edges.user.current_cs_field_name"]
        relationStatus   <- (map["curr_type"], EnumTransform())
        online   <- map["edges.user.is_online"]
        online   <- map["edges.user.is_online"]
        
    }
    
    var avatar: String {
        return thumbnailUrl ?? ""
    }
    
    var subTitle: String? {
        return fieldName
    }
    
    var relation: String? {
        return relationStatus?.display
    }
}

//extension FriendUserModel: FriendItemDisplay {
//    var subTitle: String? {
//        return fieldName
//    }
//
//    var avatar: String {
//        return thumbnailUrl ?? ""
//    }
//
//    var relation: RelationDisplay? {
//        return relationStatus?.display
//    }
//
//    var rightAction: FriendItemRightStyle {
//        return .hide
//    }
//
//}
//
private extension RelationStatus {
    
    var display: String? {
        switch self {
        case .normal:
            return ""
        case .good:
            return "🤝"
        case .close:
            return "🙌 "
        case .none:
            return nil
        }
    }
}
