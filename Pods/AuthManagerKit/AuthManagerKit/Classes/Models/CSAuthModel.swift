//
//  File.swift
//  AuthManagerKit
//
//  Created by li on 6/2/23.
//

import Foundation
import ObjectMapper

public struct AuthUserModel: Mappable {
    enum FieldStatus: String {
        case alone = "standalone"
        case multi = "multi_mode"
    }
    public var id: UInt = 0
    var createTime:String = ""
    var updateTime:String = ""
    public var name: String = ""
    public var mobileNo:String = ""
    public var regionCode:String = ""
    public var systemName: String = ""
    public var thumbnailUrl: String?
    public var birthday: String = ""
    public var schoolName: String?
    public var role: String?
    var status: FieldStatus = .alone
    public var isShowCollections: Bool?
    public var isOnline: Bool?
    var needPrivacyConfirm:Bool?
    public var edges: Dictionary<String ,Any>?
    public init?(map: ObjectMapper.Map) {
        
    }
    
    mutating public func mapping(map: ObjectMapper.Map) {
        id     <- map["id"]
        name   <- map["name"]
        systemName   <- map["system_name"]
        thumbnailUrl   <- map["thumbnail_url"]
        birthday   <- map["birthday"]
        schoolName   <- map["school_name"]
        mobileNo   <- map["mobile_no"]
        regionCode <- map["region_code"]
        needPrivacyConfirm <- map["need_privacy_confirm"]
        status   <- map["status"]
        isOnline   <- map["is_online"]
        isShowCollections   <- map["is_show_collections"]
    }
    
}


public struct LoginModel:Mappable {
    public init?(map: ObjectMapper.Map) {
        
    }
    
    public mutating func mapping(map: ObjectMapper.Map) {
        authed <- map["authed"]
        user <- map["user"]
    }
    
    var authed:Bool?
    var user: AuthUserModel?
}
