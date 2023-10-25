//
//  Mediator+AppDelegate.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/19.
//

import Foundation

public extension Mediator {
    
    
    class func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.application(application, willFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    class func applicationWillEnterForeground(_ application: UIApplication) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.applicationWillEnterForeground(application)
        }
    }
    
    class func applicationDidEnterBackground(_ application: UIApplication) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.applicationDidEnterBackground(application)
        }
    }
    
    class func applicationDidBecomeActive(_ application: UIApplication) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.applicationDidBecomeActive(application)
        }
    }
    
    class func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.application(app, open: url, options: options)
        }
    }
    
    // notification
    class func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let modules = Mediator.allRegisteredModules()
        for module in modules {
            module.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
}
