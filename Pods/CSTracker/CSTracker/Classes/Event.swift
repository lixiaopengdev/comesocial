//
//  Event.swift
//  CSTracker
//
//  Created by 于冬冬 on 2023/6/26.
//

import Foundation

extension Tracker {
    public struct Event: RawRepresentable, ExpressibleByStringLiteral {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
    }
    
}


