//
//  UIButton+Extensions.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/21.
//

import Foundation
public extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        clipsToBounds = true  // maintain corner radius
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            draw(.zero)
        }
        setBackgroundImage(colorImage, for: forState)
        return
    }
}
