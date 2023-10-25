//
//  FriendsRouterMap.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/1/9.
//

//import CSRouter
//import CSNetwork
//import CSAccountManager
//
//public enum FieldRouterMap: RouterMap {
//
//    public static func initialize(router: CSRouter.Router) {
//
//        router.register(Router.Field.listRegister){ url, values, context in
//            return FieldListViewController()
//        }
//        router.register(Router.Field.userRegister){ url, values, context in
//            let uid = values["uid"] as? String ?? ""
//            return FieldUserViewController(uid: UInt(uid) ?? 0)
//        }
//        router.register(Router.Field.fieldRegister){ url, values, context in
//            let id = values["id"] as? String ?? ""
//            return FieldViewController(id: UInt(id) ?? 0)
//        }
//        router.register(Router.Field.myFieldRegister){ url, values, context in
//            let id = AccountManager.shared.fieldId
//            return FieldViewController(id: id )
//        }
//
//
//    }
//}
