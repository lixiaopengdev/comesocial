//
//  FriendsRouterMap.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/1/9.
//

//import CSRouter
//import CSNetwork
//
//public enum LiveRouterMap: RouterMap {
//
//    public static func initialize(router: CSRouter.Router) {
//
//        router.register(Router.Live.homeRegister){ url, values, context in
//            return LiveViewController()
//        }
//
//        router.register(Router.Live.shareTimeDewRegister){ url, values, context in
//            guard let titleText = url.queryParameters["titleText"],
//                  let contentText = url.queryParameters["contentText"] else { return nil }
//            return LifeFlowShareViewController(titleText: titleText, contentText: contentText, shareURL: "https://github.com/NeoWorldTeam", photoImageURL: url.queryParameters["photoImageURL"], contentImageURL: url.queryParameters["contentImageURL"])
//        }
//
//        router.handle(Router.Live.editSaveTimeDewHandleRegister) { url, values, context in
//            guard let id = Int(url.queryParameters["id"] ?? ""),
//                  let type = url.queryParameters["type"],
//                  let edit = url.queryParameters["edit"],
//                  let editHandle = Int(edit) else { return false }
//
//            if editHandle == 1 {
//                Network.oriRequest(LifeFlowService.save(id: Int(id), type: type), completion:  { result in
//                    print("save: \(result)")
//                    switch result {
//                    case .success(_):
//                        break
//
//                    case .failure(_):
//                        break
//                    }
//                })
//            }else{
//                Network.oriRequest(LifeFlowService.cancelSave(id: id, type: type), completion:  { result in
//                    print("cancel save: \(result)")
//                    switch result {
//                    case .success(_):
//                        break
//
//                    case .failure(_):
//                        break
//                    }
//                })
//            }
//            return true
//        }
//
//        router.handle(Router.Live.doReactionTimeDewRegister) { url, values, context in
//            guard let id = Int(url.queryParameters["id"] ?? ""),
//                  let type = url.queryParameters["type"],
//                  let edit = url.queryParameters["edit"],
//                  let editHandle = Int(edit) else { return false }
//
//            if editHandle == 1 {
//                Network.oriRequest(LifeFlowService.addReaction(id: id, type: type), completion:  { result in
//                    print("addReaction: \(result)")
//                    switch result {
//                    case .success(_):
//                        break
//
//                    case .failure(_):
//                        break
//                    }
//                })
//            }else{
//                Network.oriRequest(LifeFlowService.deleteReaction(id: id, type: type), completion:  { result in
//                    print("deleteReaction: \(result)")
//                    switch result {
//                    case .success(_):
//                        break
//
//                    case .failure(_):
//                        break
//                    }
//                })
//            }
//            return true
//        }
//
//        router.handle(Router.Live.jumpFieldTimeDewRegister) { url, values, context in
//            guard let fieldId = Int(url.queryParameters["fieldId"] ?? "0") else { return false }
//
//            Network.oriRequest(LifeFlowService.jumpToField(fieldID: fieldId), completion:  { result in
//                print("jumpToField: \(result)")
//                switch result {
//                case .success(_):
//                    break
//
//                case .failure(_):
//                    break
//                }
//            })
//            return true
//        }
//
//
//        router.register(Router.Live.timeDewMoreFunctionRegister){ url, values, context in
//            guard let requestSessionId = url.queryParameters["requestSessionId"],
//                  let timeDewId = url.queryParameters["timeDewId"],
//                  let timeDewIdUI = UInt(timeDewId),
//                  let timeDewType = url.queryParameters["timeDewType"] else { return nil }
//            return MoreViewController(requsestSessionID: requestSessionId, timeDewId: timeDewIdUI, timeDewType: timeDewType, isSaveTimeDew: url.queryParameters["isSaveTimeDew"] )
//        }
//
//
//        router.handle(Router.Live.inviteJoinFieldRegister) { url, values, context in
//            guard let inviteUserId = UInt(url.queryParameters["inviteUserId"] ?? "0") else { return false }
//
//            Network.oriRequest(LifeFlowService.invite_join_field(user_id: inviteUserId), completion:  { result in
//                print("invite user save: \(result)")
//                switch result {
//                case .success(_):
//                    break
//
//                case .failure(_):
//                    break
//                }
//            })
//
//            return true
//        }
//
//
//
//
//
//    }
//}
