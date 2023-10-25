//
//  RootTabbarController.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/1/9.
//

import UIKit
import CSBaseView
import CSRouter
import CSFriendsModule
import CSMeModule
import CSAccountManager
import Combine
import CSWebsocket

import CSLiveModule
import CSFieldModule

import AuthManagerKit
import Kingfisher
import CSPermission
import Permission

class RootTabbarController: BaseTabBarController {
    
    var cancellableSet: Set<AnyCancellable> = []
    weak var rulyPermisionController: RulyPermisionController?

//    var isNewUser = false
    
    static func initializeRouterMap() {
//        LoginRouterMap.initialize(router: Router.shared)
        MeRouterMap.initialize(router: Router.shared)
        FriendsRouterMap.initialize(router: Router.shared)
        
        FieldRouterMap.initialize(router: Router.shared)
        LiveRouterMap.initialize(router: Router.shared)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check()
        initLunch()
    }
    
    func check() {
        checkLogin()
       
    }
    
    func merge(backgroundImage: UIImage?, overlayImage: UIImage) -> UIImage? {
        // 定义画布的大小，即最终合成后的图片大小
        let canvasSize = backgroundImage?.size ?? CGSize(width: 38, height: 38)
        
        // 创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        
        // 绘制背景图片
        backgroundImage?.draw(in: CGRect(origin: .zero, size: canvasSize))
        
        // 定义叠加图片的位置和大小
        let overlayRect = CGRect(x: 7, y: 7, width: 24, height: 24)
        
        // 绘制叠加图片
        overlayImage.draw(in: overlayRect)
        
        // 从图形上下文获取最终合成后的图片
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束图形上下文
        UIGraphicsEndImageContext()
        
        return mergedImage
        
    }
    
    func configNC(vc: UIViewController, image: String, selecedImage: String) -> BaseNavigationController {
        let nc = BaseNavigationController(rootViewController: vc)
        nc.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        nc.tabBarItem.selectedImage = UIImage(named: selecedImage)?.withRenderingMode(.alwaysOriginal)
        nc.tabBarItem.imageInsets = UIEdgeInsets(top: 14, left: 0, bottom: -14, right: 0)
        nc.setNavigationBarHidden(false, animated: false)
        return nc
    }
    
    func checkLogin() {
        AccountManager.shared.$isLogin.removeDuplicates().receive(on: RunLoop.main).sink { [weak self] login in
            if login {
                ConnectClient.shared.connect(id: AccountManager.shared.id)
                ConnectClient.shared.registerNamespace("default")
                SudioCollectManager.share.start()
                self?.rulyPermisionController?.showContent()
            } else {
                if self?.rulyPermisionController == nil {
                    self?.initLunch()
                }
                self?.presentLogin(animated: true)
                SudioCollectManager.share.stop()
//                ConnectClient.shared.socket?.disconnect(
            }
        }.store(in: &cancellableSet)
    }
    
    func presentLogin(animated: Bool) {
        CSAuthManager.shared.logout()
        CSAuthManager.shared.confirmAction = {[weak self] in
//            self?.isNewUser = true
            self?.initMain()
            let location: Permission = .locationWhenInUse
            location.request { _ in
            }
            let mic: Permission = .microphone
            mic.request { _ in
            }
        }

        let vc = CSAuthManager.shared.loginViewController { [weak self] authModel in
            AccountManager.shared.initAccount(authModel)
            self?.dismiss(animated: true)
        }
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
//        CSAuthManager.shared.showLoginView(self) { authModel in
//            AccountManager.shared.initAccount(authModel)
//        }
        
//        if let loginVC = Router.shared.viewController(for: LoginRouterMap.loginNamePath()) {
//            let loginNC = BaseNavigationController(rootViewController: loginVC)
////            loginNC.modalPresentationStyle = .fullScreen
//            loginNC.setNavigationBarHidden(true, animated: false)
//            present(loginNC, animated: animated)
//        }
    }
    
    func initLunch() {
        let rulyVC = RulyPermisionController(actionCallback: { [weak self] agree in
            PermissionManager.shared.timeDewAuthorized = agree
            self?.initMain()
            let location = Permission.locationWhenInUse
            location.presentDisabledAlert = false
            location.presentDeniedAlert = false

            let mic = Permission.microphone
            mic.presentDisabledAlert = false
            mic.presentDeniedAlert = false
            if agree {
                if location.status == .notDetermined || mic.status == .notDetermined{
                    location.request { _ in
                    }
                    mic.request { _ in
                    }
                }
            }

        })
        self.rulyPermisionController = rulyVC
        viewControllers = [rulyVC]
        tabBar.isHidden = true
    }
    func initMain() {
        var vcs = [UIViewController]()
        tabBar.isHidden = false
        if let friendsVC = Router.shared.viewController(for: Router.Friend.homePath()) {
            let friendsNC = configNC(vc: friendsVC, image: "tab_friend", selecedImage: "tab_friend_selected")
            friendsNC.setNavigationBarHidden(false, animated: false)
            vcs.append(friendsNC)
        }
        
        if let liveVC = Router.shared.viewController(for: Router.Live.homePath()) {
            let liveNC = configNC(vc: liveVC, image: "tab_bot", selecedImage: "tab_bot_selected")
            liveNC.setNavigationBarHidden(false, animated: false)
            vcs.append(liveNC)
        }
        //        if let fieldVC = Router.shared.viewController(for: Router.Field.listPath()) {
        //            let fieldNC = configNC(vc: fieldVC, image: "tab_field", selecedImage: "tab_field_selected")
        //            vcs.append(fieldNC)
        
        //        }
        
        
        if let meVC = Router.shared.viewController(for: Router.Me.homePath()) {
            let meNC = configNC(vc: meVC, image: "tab_my", selecedImage: "tab_my_selected")
            meNC.setNavigationBarHidden(false, animated: false)
            vcs.append(meNC)
        }
        
        viewControllers = vcs
        selectedIndex = 1
        AccountManager.shared.accountInfoChangedSubject
            .sink {[weak self] info in
                if let source = URL(string: info?.avatar ?? "") {
                    let oriImage = UIImage(named: "tab_my")
                    let selectedImage = UIImage(named: "tab_my_selected")

                    let width = 24
                    let scale = oriImage?.scale ?? 1
                    
                    let radius = RoundCornerImageProcessor(radius:.widthFraction(0.5), targetSize: CGSize(width: width, height: width))

                    KingfisherManager.shared.retrieveImage(with: source, options: [ .cacheSerializer(FormatIndicatedCacheSerializer.png), .processor(radius), .scaleFactor(scale)]) { result in
                        switch result {
                        case .success(let r):
                            print(r.image.size)
                            print(r.image.size.width * r.image.scale)
                            let image = self?.merge(backgroundImage: oriImage, overlayImage: r.image)
                            let selectedImage = self?.merge(backgroundImage: selectedImage, overlayImage: r.image)
                            self?.viewControllers?.last?.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
                            self?.viewControllers?.last?.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)

                        case .failure(_):
                            break
                        }
                    }
                }
                
            }
            .store(in: &cancellableSet)
    }
    
    func showPermission() {
        guard let vc = rulyPermisionController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}



extension AuthUserModel: AccountProtocol {
    public var field: UInt {
        return 0
    }
    
    public var avatar: String {
        return thumbnailUrl ?? ""
    }
}
