//
//  UIView+extensions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/9.
//

import UIKit

public extension UIView {
    
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    ///  Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var layerCornerRadius: CGFloat {
       get {
           return layer.cornerRadius
       }
       set {
           layer.masksToBounds = true
           layer.cornerRadius = newValue
       }
   }
    
    func cornerRadius(corners: UIRectCorner, radius: CGFloat) {
            var cornerMask: CACornerMask = []
            if corners.contains(.allCorners) {
                cornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else {
                if corners.contains(.bottomLeft) {
                    cornerMask.update(with: .layerMinXMaxYCorner)
                }
                if corners.contains(.bottomRight) {
                    cornerMask.update(with: .layerMaxXMaxYCorner)
                }
                if corners.contains(.topLeft) {
                    cornerMask.update(with: .layerMinXMinYCorner)
                }
                if corners.contains(.topRight) {
                    cornerMask.update(with: .layerMaxXMinYCorner)
                }
            }
            
            layer.cornerRadius = radius
            layer.masksToBounds = true
            layer.maskedCorners = cornerMask
    }
    
}
