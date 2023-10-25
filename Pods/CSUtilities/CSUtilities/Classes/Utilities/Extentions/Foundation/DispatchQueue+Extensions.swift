//
//  DispatchQueue+Extensions.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/3/7.
//

import Foundation

public extension DispatchQueue {
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func safeAsync(_ block: @escaping () -> Void) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}
