//
//  ComeSocialRootModule.swift
//  ComeSocialRootModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator
import CSTracker
import CSAccountManager
import CSUtilities
import IQKeyboardManagerSwift
import CSFileKit
import CSWebsocket
import Combine

#if DEBUG
import DoraemonKit
#endif


public class ComeSocialRootModule: MediatorModuleProtocol {
    
    public static let shared = ComeSocialRootModule()
    
    private var cancellableSet = Set<AnyCancellable>()
    public let priority: ModulePriority = .required
    
    public func bootstrap() {
        
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
        initialize()
        ConfigLaunchData()
        
        let window = application.delegate?.window
        let rootVC =  RootTabbarController()
        window??.rootViewController = rootVC
        window??.makeKeyAndVisible()
        
        Tracker.track(event: .openApp)
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        Tracker.track(event: .appInBackground)
    }
    
    private func initialize() {
        
        Constants.Server.domainEnviroment = .irelandTest
        Tracker.initialize(token: "9e58b460636a8c9c0b250500ff7039a6")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        FileKitConfig.uploadUrl = URL(string: Constants.Server.baseURL + "/upload")
#if DEBUG
        if Constants.Doraemon.isOpen {
            setupDoraemon()
        }
#endif
        
        
    }
    
    private func ConfigLaunchData() {
        AccountManager
            .shared
            .$isLogin
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { login in
                if login {
                    ConnectClient.shared.connect(id: AccountManager.shared.id)
                    ConnectClient.shared.registerNamespace("default")
                    Tracker.login(uid: AccountManager.shared.id)
                } else {
                    ConnectClient.shared.getNamespaceClient("default").logoutNamespace()
                    ConnectClient.shared.disconnect()
                    Tracker.logout()
                }
            }
            .store(in: &cancellableSet)
    }
}

// debug
#if DEBUG
extension ComeSocialRootModule {
    
    func setupDoraemon() {
        DoraemonManager.shareInstance().addPlugin(withTitle: "环境切换", icon: "doraemon_default", desc: "", pluginName: "", atModule: "自定义") { data in
            let alert = UIAlertController(title: "环境切换", message: "当前环境: \(Constants.Server.domainEnviroment)", preferredStyle: .actionSheet)
            
            alert.popoverPresentationController?.sourceView = UIViewController.topMost?.view
            alert.addAction(UIAlertAction(title: "dev", style: .default , handler:{ (UIAlertAction)in
                AccountManager.shared.logout()
                Constants.Environment.dev.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    exit(0)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "mini", style: .default , handler:{ (UIAlertAction)in
                AccountManager.shared.logout()
                Constants.Environment.mini.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    exit(0)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "aws", style: .default , handler:{ (UIAlertAction)in
                AccountManager.shared.logout()
                Constants.Environment.aws.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    exit(0)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "ali", style: .default , handler:{ (UIAlertAction)in
                AccountManager.shared.logout()
                Constants.Environment.ali.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    exit(0)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            DoraemonManager.shareInstance().hiddenHomeWindow()
            
            if let popoverController = alert.popoverPresentationController,
               let view = UIViewController.topMost?.view {
                popoverController.sourceView = view//to set the source of your alert
                popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            
            UIViewController.topMost?.present(alert, animated: true)
        }
        DoraemonManager.shareInstance().install(withPid: "8fa26770f4fbc084752709e2718281a8")
    }
}

#endif
