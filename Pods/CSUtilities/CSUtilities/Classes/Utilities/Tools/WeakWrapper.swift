//
//  WeakWrapper.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/15.
//

import Foundation

public class WeakWrapper<T> {
    weak var unboxed: AnyObject?
    public var value: T? {
        return unboxed as? T
    }
    
    public init(_ value: T?) {
        weak var value: AnyObject? = value as AnyObject
        self.unboxed = value
    }
}
