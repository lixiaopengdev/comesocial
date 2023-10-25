//
//  PropertiesBuilderProtocol.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/28.
//

import Foundation
import SwiftyJSON

protocol PropertiesBuilderProtocol {
    var data: JSON { get }
}

extension PropertiesBuilderProtocol {
    var string: String {
        guard let value =  data.rawString(options: []) else {
            assertionFailure("message empty")
            return ""
        }
        return value
    }
    
    var value: JSON {
        return data
    }
}
