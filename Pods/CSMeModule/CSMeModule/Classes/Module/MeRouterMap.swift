//
//  MeRouterMap.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/1/9.
//

//import CSRouter
//import SafariServices
////
//
//public enum MeRouterMap: RouterMap {
//
//
//    public static func initialize(router: CSRouter.Router) {
//        
//        router.register(Router.Me.homeRegister){ url, values, context in
//            return ProfileViewController()
//        }
//
//        router.register(Router.Me.profileRegister){ url, values, context in
//            let otherProfileVC = OtherProfileViewController()
//            let uid = values["uid"] as? String ?? ""
//            otherProfileVC.uid = UInt(uid) ?? 0
//            return otherProfileVC
//        }
//
//        router.register("http://<path:_>", webViewControllerFactory)
//        router.register("https://<path:_>", webViewControllerFactory)
//
//    }
//
//    private static func webViewControllerFactory(_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> UIViewController? {
//        let webVC = WebViewController(url: url.urlValue)
//        return webVC
//    }
//
//}

