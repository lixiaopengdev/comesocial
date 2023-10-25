//
//  Font+Extentions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/23.
//

import UIKit

public extension UIFont {

    static var boldLargeTitle: UIFont {
        return boldFont(ofSize: 34)
    }
    static var boldTitle1: UIFont {
        return boldFont(ofSize: 20)
    }
    static var boldHeadline: UIFont {
        return boldFont(ofSize: 18)
    }
    static var boldBody: UIFont {
        return semiBoldFont(ofSize: 16)
    }
    static var boldSubheadline: UIFont {
        return boldFont(ofSize: 14)
    }
    
    static var regularLargeTitle: UIFont {
        return semiBoldFont(ofSize: 34)
    }
    static var regularTitle1: UIFont {
        return semiBoldFont(ofSize: 20)
    }
    static var regularHeadline: UIFont {
        return semiBoldFont(ofSize: 18)
    }
    static var regularBody: UIFont {
        return regularFont(ofSize: 16)
    }
    static var regularSubheadline: UIFont {
        return regularFont(ofSize: 14)
    }
    static var regularFootnote: UIFont {
        return regularFont(ofSize: 12)
    }
    static var regularCaption1: UIFont {
        return semiBoldFont(ofSize: 11)
    }
    
    
    static func regularFont(ofSize fontSize: CGFloat) -> UIFont {
        return name(.nunitoSansRegular, size: fontSize)
    }
    
    static func boldFont(ofSize fontSize: CGFloat) -> UIFont {
        return name(.nunitoSansBold, size: fontSize)
    }
    static func semiBoldFont(ofSize fontSize: CGFloat) -> UIFont {
        return name(.nunitoSansSemiBold, size: fontSize)
    }
    
    static func name(_ fontName: FontName, size: CGFloat) -> UIFont {
        return FontManager.shared.name(fontName, size: size)
    }
}
