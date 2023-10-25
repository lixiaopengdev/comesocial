//
//  TimeDewFragment.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/21.
//

import Foundation
import ObjectMapper
import Combine
import SwiftyJSON

class TimeDewFragmentModel: Mappable {
    
    var urls: [String]?
    var text: String?
    var url: String? {
        return urls?.first
    }
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        urls <- map["file_urls"]
        text     <- map["gpt_text"]
    }
    
    
}

class TimeDewFragment: WidgetFragment {
    
    @Published var url: String?
    @Published var text: String?
    
    override func mapping(map: ObjectMapper.Map) {
//        align     <- (map["align"], AlignTransform())
    }
    
    override func update(full: JSON, change: JSON) {
        if let modelJson = change["model"].string {
            if let model = TimeDewFragmentModel(JSONString: modelJson) {
                url = model.url
                text = model.text
            }
        }
    }
    
    func syncModel(_ model: String) {
        syncData(value: ["model": model])
    }

    override var height: CGFloat {
        640
    }
    
    
}
