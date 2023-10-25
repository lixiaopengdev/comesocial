//
//  App.swift
//  CSConstants
//
//  Created by 于冬冬 on 2023/3/27.
//

import Foundation

public extension Device.App {
    
    enum Environment {
        /// SwifterSwift: Application is running in debug mode.
        case debug
        /// SwifterSwift: Application is installed from Test Flight.
        case testFlight
        /// SwifterSwift: Application is installed from the App Store.
        case appStore
    }
    
    /// SwifterSwift: Current inferred app environment.
    static var inferredEnvironment: Environment {
#if DEBUG
        return .debug
        
#elseif targetEnvironment(simulator)
        return .debug
        
#else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }
        
        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }
        
        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }
        
        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }
        
        return .appStore
#endif
    }
    
    static var displayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    static var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    static var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
}
