//
//  RootTabbarController.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/1/9.
//

import CSBaseView
import Combine
import CSMediator
import CSAccountManager
import CSWebsocket
import AuthManagerKit
import Kingfisher
import CSPermission
import Permission
import CSTracker

class RootTabbarController: BaseTabBarController {
    
    var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.isHidden = true
        setViewControllers([LoadingViewController()], animated: true)
        checkLogin()
        observeProfile()
    }
    
    func observeProfile() {
        Mediator
            .resolve(MeService.ProfileService.self)?
            .profileUpdatePublisher()
            .map({ return $0?.avatar})
            .removeDuplicates()
            .sink(receiveValue: {[weak self] url in
                self?.updateTabIcon(url: url)
            })
            .store(in: &cancellableSet)
    }
    
    func checkLogin() {
        let accountPublisher = AccountManager
            .shared
            .$isLogin
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
        accountPublisher
            .first()
            .sink { [weak self] login in
                if login {
                    self?.initRulyVC()
                } else {
                    self?.presentLogin(animated: false)
                }
            }
            .store(in: &cancellableSet)
        
        accountPublisher
            .dropFirst()
            .sink { [weak self] login in
                if !login {
                    self?.presentLogin(animated: true)
                }
            }
            .store(in: &cancellableSet)
        
    }
    
    func updateTabIcon(url: String?) {
        if let source = URL(string: url ?? "") {
            let oriImage = UIImage.bundleImage(named: "tab_my")
            let selectedImage = UIImage.bundleImage(named: "tab_my_selected")
            let width = 24
            let scale = oriImage?.scale ?? 1
            let radius = RoundCornerImageProcessor(radius:.widthFraction(0.5), targetSize: CGSize(width: width, height: width))
            
            KingfisherManager.shared.retrieveImage(with: source, options: [ .cacheSerializer(FormatIndicatedCacheSerializer.png), .processor(radius), .scaleFactor(scale)]) { [weak self] result in
                switch result {
                case .success(let r):
                    let frame = CGRect(x: 7, y: 7, width: 24, height: 24)
                    let image =  oriImage?.merge(overlayImage: r.image, frame: frame)
                    let selectedImage = selectedImage?.merge(overlayImage: r.image, frame: frame)
                    self?.viewControllers?.last?.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
                    self?.viewControllers?.last?.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func initRulyVC() {
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
        tabBar.isHidden = true
        setViewControllers([rulyVC], animated: true)
    }
    
    func initMain() {
        
        tabBar.isHidden = false
        var vcs = [UIViewController]()
        
        if let friendsVC =  Mediator.resolve(FriendsService.ViewControllerService.self)?.homeViewController() {
            let friendsNC = configNC(vc: friendsVC, image: "tab_friend", selecedImage: "tab_friend_selected")
            vcs.append(friendsNC)
        }
        
        if let liveVC = Mediator.resolve(LiveService.ViewControllerService.self)?.homeViewController() {
            let liveNC = configNC(vc: liveVC, image: "tab_bot", selecedImage: "tab_bot_selected")
            vcs.append(liveNC)
        }
        
        if let meVC = Mediator.resolve(MeService.ViewControllerService.self)?.homeViewController() {
            let meNC = configNC(vc: meVC, image: "tab_my", selecedImage: "tab_my_selected")
            vcs.append(meNC)
        }
        
        setViewControllers(vcs, animated: false)
        selectedIndex = 1
    }
    
    func configNC(vc: UIViewController, image: String, selecedImage: String) -> BaseNavigationController {
        let nc = BaseNavigationController(rootViewController: vc)
        nc.tabBarItem.image = UIImage.bundleImage(named: image)?.withRenderingMode(.alwaysOriginal)
        nc.tabBarItem.selectedImage = UIImage.bundleImage(named: selecedImage)?.withRenderingMode(.alwaysOriginal)
        nc.tabBarItem.imageInsets = UIEdgeInsets(top: 14, left: 0, bottom: -14, right: 0)
        nc.setNavigationBarHidden(false, animated: false)
        return nc
    }
    
    func presentLogin(animated: Bool) {
        
        var isNewUser = false
        CSAuthManager.shared.confirmAction = {[weak self] in
            isNewUser = true
            self?.initMain()
            let location: Permission = .locationWhenInUse
            location.presentDisabledAlert = false
            location.presentDeniedAlert = false
            location.request { _ in
            }
            let mic: Permission = .microphone
            mic.presentDisabledAlert = false
            mic.presentDeniedAlert = false
            mic.request { _ in
            }
        }
        
        let vc = CSAuthManager.shared.loginViewController { [weak self] authModel in
            AccountManager.shared.initUid(authModel.id)
            if !isNewUser {
                self?.initRulyVC()
            }
            self?.dismiss(animated: true)
        }
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: animated)
        
    }
}

extension RootTabbarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        switch selectedIndex {
        case 0:
            Tracker.track(event: .exitFriendsTab)
        case 2:
            Tracker.track(event: .exitMeTab)
        default:
            break
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        switch selectedIndex {
        case 0:
            Tracker.track(event: .enterFriendsTab)
        case 2:
            Tracker.track(event: .enterMeTab)
        default:
            break
        }
    }
}
