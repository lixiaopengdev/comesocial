//
//  StackCardModel.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/29.
//

import Foundation

import ObjectMapper

enum CardType: Int {
    case unknow = -1
    case face = 1
    case party = 2
    case nftBuild = 3
    case discord = 4
    case nft = 5
    case airDrop = 6
}

struct StackCardParams : Mappable {
    var name: String?
    var value: String?
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        name   <- map["name"]
        value  <- map["value"]
    }
    
}



extension CardModel {
    
    var cardType: CardType {
        return .face
        
        if let cardType = type {
            return cardType
        }
        return .unknow
    }
}
