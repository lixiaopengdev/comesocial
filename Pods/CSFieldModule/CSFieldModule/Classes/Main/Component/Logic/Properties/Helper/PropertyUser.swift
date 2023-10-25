//
//  PropertyUser.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/28.
//

import Foundation
import SwiftyJSON


class PropertyUser: PropertiesBuilderProtocol {
    var data: JSON
    var paths: [JSONSubscriptType]

    init(json: JSON, id: String) {
        self.data = json
        paths = ["prop", "user", id]
        data["prop"]["user"] = [id: [String: Any]()]
    }
    
    func openVideo(_ open: Bool) -> PropertyUser {
        data[paths]["video"].bool = open
        return self
    }
    
    func changePhoto(_ photo: String) -> PropertyUser {
        data[paths]["photo"].string = photo
        return self
    }
    
    func setNull() -> PropertyUser {
        data[paths] = JSON.null
        return self
    }
    
    func updateWidget(_ value: JSON) -> PropertyUser {
        data[paths] = value
        return self
    }

}
