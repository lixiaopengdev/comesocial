//
//  LifeFlowModel.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/3/29.
//

import Foundation
import ObjectMapper

struct LifeFlowModel: Mappable {

    var lifeFlowTimeStamp: Int64 = 0
    var lifeFlow: [LifeFlowItemModel] = []
    init?(map: ObjectMapper.Map) {

    }

    mutating func mapping(map: ObjectMapper.Map) {
        lifeFlowTimeStamp  <- map["lifeFlowTimeStamp"]
        lifeFlow <- map["lifeFlow"]
    }

}

struct LifeFlowReactionsModel: Mappable {
    var name: String?
    var id: Int = 0
    init?(map: ObjectMapper.Map) {
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id              <- map["id"]
        name            <- map["name"]
    }
}


struct LifeFlowItemModel: Mappable {
    
    var id: UInt = 0
    var type: String?
    var timeStamp: Int64 = 0
    var title: String?
    var onwerId: String?
    var onwerThumb: String?
    var content: String?
    var imageUrl: String?
    var fieldID: UInt = 0
    var is_saved: Bool = false
    var reactions:[String : [LifeFlowReactionsModel]] = [:]
    var members:[Int]? = nil
    var members_thumbs:[String]? = nil
    
    init?(map: ObjectMapper.Map) {

    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id              <- map["id"]
        timeStamp       <- map["timeStamp"]
        title           <- map["title"]
        onwerId         <- map["onwerId"]
        content         <- map["content"]
        imageUrl        <- map["pic_url"]
        type            <- map["time_dew_type"]
        onwerThumb      <- map["onwerThumb"]
        fieldID         <- map["cs_field_id"]
        is_saved        <- map["is_saved"]
        reactions       <- map["reactions"]
        members         <- map["members"]
        members_thumbs  <- map["members_thumbs"]
    }
    
    init(id: UInt) {
    }
    
}
