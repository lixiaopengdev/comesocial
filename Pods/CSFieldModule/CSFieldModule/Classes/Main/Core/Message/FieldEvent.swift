//
//  FieldEvent.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/13.
//

import Foundation

enum FieldEvent: String {
    
    // widget
    case renderWidget = "renderWidget"
    case brodcastAction = "brodcastAction"
    
    // user
    case roomInfo = "roomInfo"
    case userJoin = "userJoin"
    case userLeft = "userLeft"
    case propUpdate = "prop_update"
    case widgetMessage = "widget_message"

    // Tets
    case unknow = "unknow"
    
    init(_ eventName: String?) {
        self = FieldEvent(rawValue: eventName ?? "") ?? .unknow
    }
    
}

