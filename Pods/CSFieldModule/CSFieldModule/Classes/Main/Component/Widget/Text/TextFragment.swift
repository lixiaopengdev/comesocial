//
//  TextFragment.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/3.
//

import Foundation
import ObjectMapper
import CSUtilities
import UIKit

class TextFragment: WidgetFragment {
    
    var label: String = ""
    var align: NSTextAlignment = .center
    var font: UIFont = UIFont.name(.avenirNextRegular, size: 17)
    
    
    override func mapping(map: ObjectMapper.Map) {
        label     <- map["label"]
        align     <- (map["align"], AlignTransform())
        font     <- (map["font"], FontTransform())
        
    }
    
    override var height: CGFloat {
        20
    }
    
    
}

