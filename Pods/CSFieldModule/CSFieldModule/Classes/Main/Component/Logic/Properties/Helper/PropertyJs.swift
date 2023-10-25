//
//  PropertyJs.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/28.
//

import Foundation
import SwiftyJSON

class PropertyJs: PropertiesBuilderProtocol {
    var data: JSON
    
    init(json: JSON, card: CardModel) {
        self.data = json
        data["prop"]["js"].dictionaryObject = [card.idString: card.idString]
    }
    
}
