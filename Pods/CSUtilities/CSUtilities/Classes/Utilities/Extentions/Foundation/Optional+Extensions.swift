//
//  Optional+Extensions.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/3/21.
//

import Foundation
public extension Optional {
    
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
    
    func unwrapped(or error: Error) throws -> Wrapped {
        guard let wrapped = self else { throw error }
        return wrapped
    }
    
    func run(_ block: (Wrapped) -> Void) {
        _ = map(block)
    }
}

public extension Optional where Wrapped: Collection {
    
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }

    var nonEmpty: Wrapped? {
        guard let collection = self else { return nil }
        guard !collection.isEmpty else { return nil }
        return collection
    }
}
