//
//  HiddenUserModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/6.
//

import Foundation
import ObjectMapper
import CSCommon

struct HiddenUserModel: Mappable {
    
    var id: UInt = 0
    var name: String = ""
    var thumbnailUrl: String?
    var fieldName: String?
    var online: Bool = false
    var regionCode: String?
    var mobileNo: String?

    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id     <- map["id"]
        name   <- map["name"]
        thumbnailUrl   <- map["thumbnail_url"]
        fieldName   <- map["current_cs_field_name"]
        online   <- map["is_online"]
        regionCode   <- map["region_code"]
        mobileNo   <- map["mobile_no"]

    }
    var avatar: String {
            return thumbnailUrl ?? ""
        }
}

//extension HiddenUserModel: FriendItemDisplay {
//    var subTitle: String? {
//        return nil
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
//        return .enable("Recover")
//    }
//
//}
