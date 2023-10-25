//
//  RelationFriendSectionDisplay.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/16.
//

import Foundation
import CSCommon

//public class RelationFriendSectionDisplay: SectionDisplay {
//    public var fold: Bool?
//    public var items: [ItemDisplay]
//    private let relation: RelationDisplay?
//    public var rightAttributedTitle: NSAttributedString?
//
//    public var leftTitle: String? {
//        guard let relation = self.relation else { return "Friends" }
//        switch relation {
//        case .none:
//            return "Friends"
//        case .friend:
//            return "Close Friends"
//        case .close:
//            return "Best Friends"
//        }
//    }
//
//    public init(relation: RelationDisplay?, ori: [FriendItemDisplay]) {
//        fold = false
//        self.relation = relation
//        if let relation = relation {
//            items = ori.filter({ $0.relation == relation })
//        } else {
//            items = ori
//        }
//        let onlineItems = items.filter({ ($0 as! FriendItemDisplay).online })
//        rightAttributedTitle = NSAttributedString(string: "\(onlineItems.count)/\(items.count)").font(.regularCaption1)
//    }
//
//}
