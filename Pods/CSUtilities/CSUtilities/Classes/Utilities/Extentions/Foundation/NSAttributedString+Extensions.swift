//
//  NSAttributedString+Extensions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/19.
//

import Foundation
import UIKit

public extension NSAttributedString {
    
    func font(_ font: UIFont, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    func foregroundColor(_ foregroundColor: UIColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string, attributes: attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    func attributes() -> [NSAttributedString.Key: Any] {
        guard !string.isEmpty else { return [:] }
        return attributes(at: 0, longestEffectiveRange: nil, in: attributedStringRange(nil))
    }
    
    private func attributedStringRange(_ range: NSRange?) -> NSRange {
        range ?? NSRange(location: 0, length: string.count)
    }
    
    
}

public extension NSAttributedString {
    
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }
    
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }
    
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
}
