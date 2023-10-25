//
//  CardModel.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/6.
//

import ObjectMapper


struct CardModel: Mappable {
    
    var id: Int = 0
    var name: String?
    var description: String?
    var scriptUrl: String?

    var count: Int?
    var type: CardType?
    var coverURL: String?
    var backCoverURL: String?
    var ownerId: String?
    var params: [StackCardParams]?
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id     <- map["id"]
        name   <- map["name"]
        description   <- map["description"]
        scriptUrl   <- map["script_url"]
        coverURL   <- map["cover"]
        
        count  <- map["count"]
        type  <- map["type"]
        coverURL  <- map["coverURL"]
        backCoverURL  <- map["backCoverURL"]
        ownerId  <- map["ownerId"]
        params  <- map["params"]

    }
    
}

extension CardModel {
    var displayName : String {
        return name?.replacingOccurrences(of: " ", with: "\n") ?? "empty name"
    }
    var idString: String {
        return String(id)
    }
}
