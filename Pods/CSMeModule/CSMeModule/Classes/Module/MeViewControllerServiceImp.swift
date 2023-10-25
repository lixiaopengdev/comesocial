//
//  MeViewControllerServiceImp.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator

struct MeViewControllerServiceImp: MeViewControllerService {
    func homeViewController() -> UIViewController {
        return ProfileViewController()
    }
    
    func profileViewController(uid: UInt) -> UIViewController {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.uid = UInt(uid)
        return otherProfileVC
    }
    
    func webViewController(url: URL?) -> UIViewController {
        return WebViewController(url: url)
    }
    
}
