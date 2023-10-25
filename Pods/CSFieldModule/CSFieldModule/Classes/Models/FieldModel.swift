//
//  FieldModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/3.
//

import ObjectMapper
import CSAccountManager
import SwiftyJSON

struct FieldModel: Mappable {
    
    var id: UInt = 0
    var name: String = ""
    var type: String?
    var mode: String?

    var uid: UInt = 0

    var users: [FieldUserModel] = []
    var properties: JSON = JSON()
    
    init?(map: ObjectMapper.Map) {
        
    }

    mutating func mapping(map: ObjectMapper.Map) {
        id     <- map["cs_field.id"]
        name   <- map["cs_field.name"]
        type  <- map["cs_field.type"]
        mode  <- map["cs_field.mode"]
        uid  <- map["cs_field.uid"]
        
        users <- map["cs_field.edges.joined_user"]
        var liveStatus: [String: Any] = [:]
        liveStatus <- map["live_status"]
        properties = JSON(liveStatus)
    }
    
}

struct RoomInfoModel: Mappable {
    
    var users: [FieldUserModel] = []
    
    init?(map: ObjectMapper.Map) {
        users <- map["edges.joined_user"]
    }

    mutating func mapping(map: ObjectMapper.Map) {
        users <- map["cs_field.edges.joined_user"]
    }
    
}
