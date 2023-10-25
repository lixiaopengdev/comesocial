//
//  ProperitesKey.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/22.
//

import Foundation
import SwiftyJSON

typealias PK = ProperitesKey
typealias PA = ProperitesAction

enum ProperitesKey: String {
    
    case version
    case prop
    case action
    case widget
    case js
    case user
    case info
//    case data

}

extension ProperitesKey: JSONSubscriptType {
    var jsonKey: SwiftyJSON.JSONKey {
        return .key(self.rawValue)
    }
}
