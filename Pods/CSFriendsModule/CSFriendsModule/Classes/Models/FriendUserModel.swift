//
//  FriendUserModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/4/3.
//

import ObjectMapper
import CSAccountManager
import CSCommon
//
//struct FieldModel: Mappable {
//    
//    var id: UInt = 0
//    var name: String = ""
//    
//    init?(map: ObjectMapper.Map) {
//        
//    }
//    mutating func mapping(map: ObjectMapper.Map) {
//        id     <- map["id"]
//        name   <- map["name"]
//    }
//}
//
//
//
//struct FriendUserModel: Mappable {
//    // data
//    var id: UInt = 0
//    var name: String = ""
//    var avatar: String = ""
//    var online: Bool = false
//    var relation:FriendRelation?
//    var field: FieldModel?
//    
//    init?(map: ObjectMapper.Map) {
//        
//    }
//    
//    mutating func mapping(map: ObjectMapper.Map) {
//        id     <- map["id"]
//        name   <- map["name"]
//        avatar  <- map["avatar"]
//        avatar = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1683105048&t=858875bf4e253fe95ef0534174afd65e"
//        online  <- map["online"]
//        relation  <- map["relation"]
//        field  <- map["field"]
//    }
//    
//}
//
//extension FriendUserModel: FriendItemDisplay {
//
//    var subTitle: String? {
//        return field?.name
//    }
//    
//    var rightAction: FriendItemRightStyle {
//        switch id % 3 {
//        case 0:
//            return .hide
//        case 1:
//            return .disable("Waiting...")
//        default:
//            return .enable("Invite")
//        }
//    }
//    
//
//    
//}
