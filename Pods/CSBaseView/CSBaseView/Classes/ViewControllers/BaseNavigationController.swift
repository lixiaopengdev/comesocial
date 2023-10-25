//
//  BaseNavigationController.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/1/9.
//


import UIKit

open class BaseNavigationController: UINavigationController {
    
    var appearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance.init()
        
        let titleAtt:[NSAttributedString.Key: Any] = [.foregroundColor: UIColor.cs_pureWhite,
                                                       .font: UIFont.boldTitle1]
        let largeTitleAtt:[NSAttributedString.Key: Any] = [.foregroundColor: UIColor.cs_pureWhite,
                                                       .font: UIFont.boldLargeTitle]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowImage = UIImage.init()
        appearance.shadowColor = UIColor.clear
        appearance.titleTextAttributes = titleAtt
        appearance.largeTitleTextAttributes = largeTitleAtt
        return appearance
    }()
    
//    var smallAppearance: UINavigationBarAppearance = {
//        let appearance = UINavigationBarAppearance.init()
//        let dic = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        let largeDic = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.clear
//        appearance.shadowImage = UIImage.init()
//        appearance.shadowColor = UIColor.clear
//        appearance.titleTextAttributes = dic
//        appearance.largeTitleTextAttributes = largeDic
//        return appearance
//    }()

    open override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barStyle = .black
        navigationBar.tintColor = .white
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            self.navigationBar.compactScrollEdgeAppearance = appearance
        }

    }
    
//   public func useSmallAppearance() {
////        navigationBar.prefersLargeTitles = false
//        self.navigationBar.standardAppearance = smallAppearance
//        self.navigationBar.scrollEdgeAppearance = smallAppearance
//    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    
    // MARK: 旋转
    open override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    
}
