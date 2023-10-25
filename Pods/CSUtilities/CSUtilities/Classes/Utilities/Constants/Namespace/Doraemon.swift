//
//  Doraemon.swift
//  CSConstants
//
//  Created by 于冬冬 on 2023/3/27.
//

import Foundation

public extension Constants {
    
    public struct Doraemon {
        public static var isOpen: Bool {
#if DEBUG
            return true
#endif
            return UserDefaults.standard.bool(forKey: "Doraemon")
        }
        
        public static func save(_ value: Bool) {
            UserDefaults.standard.set(value, forKey: "Doraemon")
            UserDefaults.standard.synchronize()
        }
        
    }
}
