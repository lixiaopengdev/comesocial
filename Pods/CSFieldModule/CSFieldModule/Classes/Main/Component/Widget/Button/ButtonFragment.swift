//
//  ButtonFragment.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/3.
//

import Foundation
import ObjectMapper
import CSUtilities
import UIKit
import JSEngineKit

struct ButtonFragmentAction: Mappable {
    
    var id: String
    var action: String?
    var args: [String]?
    
    
    init?(map: ObjectMapper.Map) {
        guard let id: String = try? map.value("id") else{
            return nil
        }
        self.id = id
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        action     <- map["action"]
        args     <- map["args"]
    }
    
}

class ButtonFragment: WidgetFragment {
    
    var title: String = ""
    var icon: String?
    var primary: Bool?
    var action: ButtonFragmentAction?

    
    override func mapping(map: ObjectMapper.Map) {
        title     <- map["title"]
        icon     <- map["icon"]
        primary     <- map["primary"]
        action     <- map["action.commonAction"]

    }
    
    override var height: CGFloat {
        34
    }
    
    func callAction() {
        guard let actionName = action?.action,
        let instanceid = parentComponent?.instanceid else {
            return
        }
        var args = action?.args ?? [String]()
//        args.append("empty")
//        args.append(parentComponent?.id ?? "")
//        args.append(id)
        YZJSEngineManager.shared().callJSMethod(actionName, instanceId: instanceid, args: args)
    }

    
}

