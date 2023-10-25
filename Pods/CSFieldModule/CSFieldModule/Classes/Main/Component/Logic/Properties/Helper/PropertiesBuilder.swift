//
//  PropertiesBuilder.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/27.
//

import Foundation
import SwiftyJSON

class PropertiesBuilder: PropertiesBuilderProtocol {
    var data: JSON = JSON()
    static func action(_ action: ProperitesAction) -> PropertiesBuilder {
        var builder = PropertiesBuilder()
        builder.data["action"].string = action.rawValue
        return builder
    }
    
    func widget(_ identifier: String) -> PropertyWidget {
        addProp()
        return PropertyWidget(json: data, id: identifier)
    }

    func js(_ card: CardModel) -> PropertyJs {
        addProp()
        return PropertyJs(json: data, card: card)
    }

    func user(_ userId: UInt) -> PropertyUser {
        addProp()
        return PropertyUser(json: data, id: String(userId))
    }
    
    func info(_ info: JSON) -> PropertyInfo {
        addProp()
        return PropertyInfo(json: data, info: info)
    }
    
    private func addProp() {
        if data["prop"].dictionaryObject == nil {
            data["prop"].dictionaryObject = [String: Any]()
        }
    }

}




