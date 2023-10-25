//
//  Define.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/19.
//

public struct ModulePriority: RawRepresentable, ExpressibleByIntegerLiteral {
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(integerLiteral value: Int) {
        self.rawValue = value
    }
    
    public static func + (lhs: ModulePriority, rhs: ModulePriority) -> ModulePriority {
        return ModulePriority(rawValue: lhs.rawValue + rhs.rawValue)
    }
    
    public static func - (lhs: ModulePriority, rhs: ModulePriority) -> ModulePriority {
        return ModulePriority(rawValue: lhs.rawValue - rhs.rawValue)
    }
}

public extension ModulePriority {
    static let required: ModulePriority  = 900
    static let high: ModulePriority  = 800
    static let defaul: ModulePriority  = 500
    static let low: ModulePriority  = 200
}
