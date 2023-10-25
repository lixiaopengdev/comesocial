//
//  BaseTabBarController.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/1/9.
//

import UIKit
import CSUtilities

open class BaseTabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        tabBar.tintColor = .white
        
        let backCoverView = UIView()
        tabBar.addSubview(backCoverView)
        backCoverView.backgroundColor = .cs_primaryBlack

        
        let ovalView = UIView()
        tabBar.addSubview(ovalView)
        ovalView.backgroundColor = .cs_darkBlue
        ovalView.layer.cornerRadius = 33
        ovalView.clipsToBounds = true
        
        backCoverView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(ovalView.snp.centerY)
        }
        ovalView.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.height.equalTo(66)
            make.top.equalToSuperview()
        }

    }
    
    
    open override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

}

