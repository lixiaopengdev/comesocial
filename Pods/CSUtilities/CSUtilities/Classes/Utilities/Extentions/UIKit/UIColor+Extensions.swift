//
//  UIColor+Extensions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/13.
//

import UIKit

public extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(((hex & 0xFF0000) >> 16)) / 255.0, green: CGFloat(((hex & 0xFF00) >> 8)) / 255.0, blue: CGFloat((hex & 0xFF)) / 255.0, alpha: alpha)
    }
    
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)

        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
}
