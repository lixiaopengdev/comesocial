//
//  Utilities.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/31.
//

import Foundation

enum Utilities {
    static func escapeMessageField(_ s: String) -> String {
        let result = s.replacingOccurrences(of: String(MD.messageSeparator), with: MD.messageFieldSeparatorReplacement)
        return result
    }
    
    static func unescapeMessageField(_ s: String) -> String {
        
        let result = s.replacingOccurrences(of:MD.messageFieldSeparatorReplacement, with: String(MD.messageSeparator))
        return result
    }
    
    static func splitN(s: String, sep: Character, limit: Int) -> [String] {
        if limit == 0 { return [s] }
        let arr = s.split(separator: sep, maxSplits: limit - 1, omittingEmptySubsequences: false).map({String($0)})
        if limit != arr.count { return [s] }
        return arr
    }
}
