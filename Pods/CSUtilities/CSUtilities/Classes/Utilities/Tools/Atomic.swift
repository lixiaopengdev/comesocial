//
//  Atomic.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/13.
//

import Foundation

@propertyWrapper
final class Atomic<Value> {
    private var lock = NSLock()

    private var value: Value

    var wrappedValue: Value {
        get {
            lock.lock(); defer { lock.unlock() }
            return value
        }

        set {
            lock.lock(); defer { lock.unlock() }
            value = newValue
        }
    }

    init(wrappedValue value: Value) {
        self.value = value
    }
}
