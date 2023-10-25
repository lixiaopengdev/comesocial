//
//  FieldUser.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/7.
//

import ObjectMapper
import CSAccountManager
import CSMediator

struct FieldUserModel: Mappable {
    
    let id: UInt
    var name: String = ""
    var avatar: String?
    
    init?(map: ObjectMapper.Map) {
        guard let id: UInt = try? map.value("id") else{
            return nil
        }
        self.id = id
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        name   <- map["name"]
        avatar   <- map["thumbnail_url"]

    }
    
    init(id: UInt) {
        self.id = id
    }
    
}

extension FieldUserModel {
    static func createMine() -> FieldUserModel {
        var user = FieldUserModel(id: AccountManager.shared.id)
        let profile = Mediator.resolve(MeService.ProfileService.self)?.profile
        user.name = profile?.name ?? ""
        user.avatar = profile?.avatar
        return user
    }
}
