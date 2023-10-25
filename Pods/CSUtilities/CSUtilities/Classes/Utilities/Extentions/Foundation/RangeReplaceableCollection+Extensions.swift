//
//  RangeReplaceableCollection+Extensions.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/3/17.
//

import Foundation

public extension RangeReplaceableCollection {
    @discardableResult
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
}
