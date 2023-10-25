//
//  PropertyInfo.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/16.
//

import Foundation
import SwiftyJSON

class PropertyInfo: PropertiesBuilderProtocol {
    var data: JSON
    
    init(json: JSON, info: JSON) {
        self.data = json
        data["prop"]["info"] = info
    }
    
}
