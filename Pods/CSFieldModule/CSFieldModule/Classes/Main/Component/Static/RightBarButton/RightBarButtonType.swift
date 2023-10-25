//
//  RightBarButtonType.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/22.
//

import Foundation

extension RightBarButton {
    enum BarButtonType: Int {
         case more
         case quit
         case friend
         case property
         case dew
         case close
        
        var buttonImageName: String {
            switch self {
            case .more:
                return "corner_more_dark"
            case .quit:
                return "corner_quit_dark"
            case .friend:
                return "corner_friend_dark"
            case .property:
                return "corner_property_dark"
            case .dew:
                return "corner_dew_dark"
            case .close:
                return "corner_close_dark"
            }
        }
     }
}
