//
//  String+Extensions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/13.
//

import Foundation

// MARK: - NSString extensions

public extension String {
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
    var deletingLastPathComponent: String {
        NSString(string: self).deletingLastPathComponent
    }

    var deletingPathExtension: String {
        NSString(string: self).deletingPathExtension
    }
    
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    static func calculateHeight(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        var size = CGSize.zero
        
        if !text.isEmpty {
            let frame: CGRect = text.boundingRect(with: CGSize(width: width, height: 999_999), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            size = CGSize(width: frame.size.width, height: frame.size.height + 1)
        }
        return size.height
    }
    
    func calculateHeight(width: CGFloat, font: UIFont) -> CGFloat {
        return String.calculateHeight(width: width, font: font, text: self)
    }
    
}
