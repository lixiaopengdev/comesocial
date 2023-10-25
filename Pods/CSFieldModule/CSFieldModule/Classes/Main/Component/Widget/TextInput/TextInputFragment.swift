//
//  TextInputFragment.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/16.
//

import Foundation
import ObjectMapper
import Combine
import SwiftyJSON

class TextInputFragment: WidgetFragment {
    
    @Published var text: String = ""
    
    var label: String = ""
    var align: NSTextAlignment = .center
    var font: UIFont = UIFont.name(.avenirNextRegular, size: 17)
    var limit: Int = -1
    
    override func mapping(map: ObjectMapper.Map) {
        label     <- map["label"]
        align     <- (map["align"], AlignTransform())
        font     <- (map["font"], FontTransform())
        limit     <- map["limit_count"]
        text = label
    }
    
    override func update(full: JSON, change: JSON) {
        if let newText = change["text"].string {
            text = newText
        }
    }
    
    func syncText(_ text: String) {
        syncData(value: ["text": text])
    }
    
    
    override var height: CGFloat {
        140
    }
    
    
}
