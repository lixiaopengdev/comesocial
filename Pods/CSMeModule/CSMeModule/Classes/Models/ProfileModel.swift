//
//  ProfileModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/25.
//

import ObjectMapper

class ProfileModel: Mappable {
    
    var collections: [CollectionModel] = []
    var friendships: [Int] = []
    var user: UserModel?
    private var relation: UserRelation = .none
    private var isWating: Bool = false
    private var isHidden: Bool = false
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        user     <- map["user_info"]
        friendships   <- map["friendships"]
        collections   <- map["collections.lifeFlow"]
        relation <- (map["friendship_status"], EnumTransform())
        isWating <- map["is_waiting"]
        isHidden <- map["is_hidden"]
        
        user?.relation = relation
        user?.isWating = isWating
        user?.isHidden = isHidden
        
    }
    
}
