//
//  AppDelegate.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/1/9.
//

import UIKit
import CSMediator
import ComeSocialRootModule
import CSLiveModule
import CSFriendsModule
import CSFieldModule
import CSMeModule

#if DEBUG
import DoraemonKit
#endif
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Mediator.registerModuleInstance(ComeSocialRootModule.shared)
        Mediator.registerModuleInstance(LiveModule.shared)
        Mediator.registerModuleInstance(FriendsModule.shared)
        Mediator.registerModuleInstance(FieldModule.shared)
        Mediator.registerModuleInstance(MeModule.shared)

        Mediator.bootstrap()
        
        Mediator.application(application, willFinishLaunchingWithOptions: launchOptions)
#if DEBUG
        setupDoraemon()
#endif
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Mediator.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Mediator.applicationWillEnterForeground(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Mediator.applicationDidEnterBackground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Mediator.applicationDidBecomeActive(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Mediator.application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Mediator.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
}

// debug
#if DEBUG
extension AppDelegate {
    
    func setupDoraemon() {
//        DoraemonManager.shareInstance().addPlugin(withTitle: "环境切换", icon: "doraemon_default", desc: "", pluginName: "", atModule: "自定义") { data in
//            let alert = UIAlertController(title: "环境切换", message: "当前环境: \(Constants.Server.domainEnviroment)", preferredStyle: .actionSheet)
//
//            alert.popoverPresentationController?.sourceView = UIViewController.topMost?.view
//            alert.addAction(UIAlertAction(title: "dev", style: .default , handler:{ (UIAlertAction)in
//                AccountManager.shared.logout()
//                Constants.Environment.dev.save()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    exit(0)
//                }
//            }))
//
//            alert.addAction(UIAlertAction(title: "mini", style: .default , handler:{ (UIAlertAction)in
//                AccountManager.shared.logout()
//                Constants.Environment.mini.save()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    exit(0)
//                }
//            }))
//
//            alert.addAction(UIAlertAction(title: "aws", style: .default , handler:{ (UIAlertAction)in
//                AccountManager.shared.logout()
//                Constants.Environment.aws.save()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    exit(0)
//                }
//            }))
//
//            alert.addAction(UIAlertAction(title: "ali", style: .default , handler:{ (UIAlertAction)in
//                AccountManager.shared.logout()
//                Constants.Environment.ali.save()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    exit(0)
//                }
//            }))
//
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
//
//            }))
//            DoraemonManager.shareInstance().hiddenHomeWindow()
//
//            if let popoverController = alert.popoverPresentationController,
//               let view = UIViewController.topMost?.view {
//                popoverController.sourceView = view//to set the source of your alert
//                popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
//                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
//            }
//
//            UIViewController.topMost?.present(alert, animated: true)
//        }
        DoraemonManager.shareInstance().install(withPid: "8fa26770f4fbc084752709e2718281a8")
    }
}

#endif
