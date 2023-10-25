//
//  CollectionModel.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/25.
//

import ObjectMapper

struct CollectionModel: Mappable {

    var id: UInt = 0
    var content: String = " "
    var pic: String?
    var title: String?
    var onwerThumb: String?
    var timeStamp: Int64?
    
    
    

    var type: String?
    var reactions: [String: [String]]?
    var isSave: Bool?
    var fieldID: UInt?
    var onwerID: String?
    var members: [Int]?
    var members_thumbs:[String]?

    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id              <- map["id"]
        content         <- map["content"]
        pic             <- map["pic_url"]
        title           <- map["title"]
        onwerThumb      <- map["onwerThumb"]
        timeStamp       <- map["timeStamp"]
        
        type            <- map["time_dew_type"]
        reactions       <- map["reactions"]
        isSave          <- map["is_saved"]
        fieldID         <- map["cs_field_id"]
        onwerID         <- map["onwerId"]
        members         <- map["members"]
        members_thumbs  <- map["members_thumbs"]

    }
}

struct CollectionListModel: Mappable {
    var lifeFlow: [CollectionModel] = []
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        lifeFlow <- map["lifeFlow"]
    }
    
}
