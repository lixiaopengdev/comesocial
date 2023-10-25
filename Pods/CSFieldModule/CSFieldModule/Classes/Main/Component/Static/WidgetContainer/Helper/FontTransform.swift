//
//  FontTransform.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/3.
//


import Foundation
import ObjectMapper


class FontTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> UIFont? {
        guard let size = value as? Int else {
            return nil
        }
        return UIFont.name(.avenirNextRegular, size: CGFloat(size))
    }
    
    func transformToJSON(_ value: UIFont?) -> Int? {
        guard let font = value else { return nil }
      
        return Int(font.pointSize)
    }
    
}
