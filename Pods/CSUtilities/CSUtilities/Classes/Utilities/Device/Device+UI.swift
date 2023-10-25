//
//  Device+UI.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/13.
//

import UIKit

public extension Device.UI {
    
    static var screenWidth: CGFloat {
        screenSize.width
    }
    
    static var screenHeight: CGFloat {
        screenSize.height
    }
    
    static var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
    }
}
