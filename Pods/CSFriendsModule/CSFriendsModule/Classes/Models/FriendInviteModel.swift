//
//  FriendInviteModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/5.
//

import ObjectMapper
import CSCommon

class FriendInviteModel: Mappable  {
    
    var users: [CommonUserModel] = []
    var link: String?
    
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        users   <- map["you_might_know_them"]
        link   <- map["invite_via_link"]
    }
    
    //    var subTitle: String? {
    //        return status
    //    }
}
//
//import Foundation
//import ObjectMapper
//import CSCommon
//
//struct InviteUserModel: Mappable {
//    
//    var id: UInt = 0
//    var name: String = ""
//    var thumbnailUrl: String?
//    var status: String?
////    var relation: RelationStatus = .none
//    var online: Bool = false
//
//    init?(map: ObjectMapper.Map) {
//        
//    }
//    
//    mutating func mapping(map: ObjectMapper.Map) {
//        id     <- map["id"]
//        name   <- map["name"]
//        thumbnailUrl   <- map["user_thumbnail"]
//        status   <- map["status"]
////        relation   <- map["current_cs_field_name"]
//        online   <- map["is_online"]
//
//    }
//}
//
//extension InviteUserModel: FriendItemDisplay {
//    
//    var subTitle: String? {
//        return status
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
//        return .enable("Add")
//    }
//
//}
