//
//  BichonAppDelegate.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/16.
//


public typealias MediatorModuleProtocol = MediatorAppDelegate & MediatorModuleInitProtocol

public protocol MediatorModuleInitProtocol: AnyObject {
    
    func bootstrap()
    var priority: ModulePriority { get }
    var synchronously: Bool { get }
}

public protocol MediatorAppDelegate: AnyObject {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    
    // notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
}

public extension MediatorAppDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?){}
    func applicationWillEnterForeground(_ application: UIApplication){}
    func applicationDidEnterBackground(_ application: UIApplication){}
    func applicationDidBecomeActive(_ application: UIApplication){}
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]){}
    
    // notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){}
}

public extension MediatorModuleInitProtocol {
    var priority: ModulePriority {
        return .defaul
    }
    
    var synchronously: Bool {
        return true
    }
}

