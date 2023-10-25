//
//  UserModel.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/23.
//

import ObjectMapper
import CSListView

enum UserRelation: String {
    case none
    case normal
    case good
    case closed
}

class UserModel: Mappable {
    
    enum FieldStatus: String {
        case alone = "standalone"
        case multi = "multi_mode"
    }
    var id: UInt = 0
    var name: String = ""
    var systemName: String = ""
    var thumbnailUrl: String?
    var birthday: String?
    var schoolName: String?
    /// BIO
    var bio: String?
    var status: FieldStatus = .alone
    var isShowCollections: Bool?
    var isOnline: Bool?
    var mobile: String?
    var constellation: String?
    var totalConnections: Int = 0
    var relation: UserRelation = .none
    var isWating: Bool = false
    var isHidden: Bool = false

    var currentFieldId: UInt?
    var privateFieldId: UInt?
    var currentFieldName: String?
    var privateFieldName: String?

    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        id     <- map["id"]
        name   <- map["name"]
        systemName   <- map["system_name"]
        thumbnailUrl   <- map["thumbnail_url"]
        birthday   <- map["birthday"]
        schoolName   <- map["school_name"]
        bio   <- map["bio"]
        status   <- map["status"]
        isOnline   <- map["is_online"]
        isShowCollections   <- map["is_show_collections"]
        mobile   <- map["mobile_no"]
        constellation   <- map["constellation"]
        totalConnections   <- map["total_connections"]
        
        currentFieldId   <- map["current_cs_field_id"]
        currentFieldName   <- map["current_cs_field_name"]
        
        privateFieldId   <- map["private_cs_field_id"]
        privateFieldName   <- map["private_cs_field_name"]

    }
    
}

extension UserModel {
    var mobileDisplay: String {
        return mobile ?? "xxx-xxx-xxxx"
    }
    
    var labels: [String] {
        var labels = [String]()
        if let school = schoolName {
            labels.append(school)
        }
        if let constellation = constellation {
            labels.append(constellation)
        }
        return labels
    }

    var subName: String? {
        let subName = systemName
        return "@\(subName) · \(totalConnections) connections"
    }
    
    var action: ProfileButtonViewModel? {
        if isWating {
            return ProfileButtonViewModel(title: "Waiting for Response...", image: UIImage.bundleImage(named: "button_icon_add_friends"), enable: false)
        }
        if needBuildConnection {
            return ProfileButtonViewModel(title: "Build Connection", image: UIImage.bundleImage(named: "button_icon_add_friends"), enable: true)
        }
        if currentFieldId != nil {
            return ProfileButtonViewModel(title: "In \(currentFieldName ?? "Field")", image: UIImage.bundleImage(named: "button_icon_join"), enable: true)
        }
        return nil
    }
    
    var needBuildConnection: Bool {
        return relation == .none
    }

}

