//
//  AlignTransform.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/3.
//

import Foundation
import ObjectMapper


class AlignTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> NSTextAlignment? {
        guard let align = value as? String else {
            return nil
        }
        switch align {
        case "left":
            return .left
        case "right":
            return .right
        default:
            return .center
        }
    }
    
    func transformToJSON(_ value: NSTextAlignment?) -> String? {
        guard let align = value else { return nil }
        switch align {
        case .left:
            return "left"
        case .right:
            return "right"
        default:
            return "center"
        }
    }
    
}
