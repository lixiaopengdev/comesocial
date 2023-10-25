//
//  CSViewController.swift
//  AuthManagerKit
//
//  Created by li on 5/11/23.
//

import Foundation
import CSBaseView
public typealias LoginFinishedHandler = (_ authModel:AuthUserModel) -> Void

public typealias ConfirmAction = () -> Void
public class CSAuthManager {
    public static let shared = CSAuthManager()
    private var isLogin = false
    public var loginFinishedHandler:LoginFinishedHandler?
    public var confirmAction:ConfirmAction?
    public init() {
        
    }
    
    public func loginFinished(userModel:AuthUserModel){
        self.isLogin = true
        let defaults =  UserDefaults.standard
        defaults.set(object:userModel.id, forKey: "userId")
        defaults.set(object: true, forKey: "isLogin")
        defaults.set(object: userModel.mobileNo, forKey: "mobile_no")
        self.loginFinishedHandler?(userModel)
    }
    
    public func confirmClick() {
        self.confirmAction?()
    }
    
    var isLoggedIn:Bool {
        if UserDefaults.standard.object(forKey: "userId") != nil {
            self.isLogin = true
            return self.isLogin
        }
        return self.isLogin
    }
    
    public func logout(){
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
    }
    
    public func loginViewController(_ completion:@escaping AuthFinished) -> CSLoginViewController {
        let vc = CSLoginViewController()
        vc.authFinished = completion
        return vc
    }
    
    public func showLoginView(_ viewController:UIViewController, completion:(LoginFinishedHandler?)) {
        if !self.isLogin {
            let vc = CSLoginViewController()
            vc.authFinished = { authModel in
                completion?(authModel)
                vc.dismiss(animated: true)
            }
            let nav = BaseNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            viewController.present(nav, animated: true)
        }
    }
}
