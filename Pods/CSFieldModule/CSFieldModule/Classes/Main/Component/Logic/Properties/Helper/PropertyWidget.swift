//
//  PropertyWidget.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/28.
//

import Foundation
import SwiftyJSON


class PropertyWidget: PropertiesBuilderProtocol {
    var data: JSON
    var id: String
    let paths: [JSONSubscriptType]

    init(json: JSON, id: String) {
        self.data = json
        self.id = id
        paths = ["prop", "widget", id]
        data["prop"]["widget"] = [id: [String: Any]()]
    }

    func addId() -> PropertyWidget {
        data[paths]["id"].string = id
        return self
    }
    
    func addData(_ value: [AnyHashable : Any]) -> PropertyWidget {
        data[paths]["data"] = JSON(value)
        return self
    }
    
    func addOrder(_ value: Int) -> PropertyWidget {
        data[paths]["order"].int = value
        return self
    }
    
    func addKey(_ key: String, value: JSON) -> PropertyWidget {
        data[paths][key] = value
        return self
    }
    
    func addValue(_ value: JSON) -> PropertyWidget {
        try? data[paths].merge(with: value)
        return self
    }
    
}
