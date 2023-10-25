//
//  RTCModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/7.
//

import ObjectMapper

struct RTCModel: Mappable {
    
    var rtcToken: String?
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        rtcToken   <- map["rtcToken"]
    }

}
