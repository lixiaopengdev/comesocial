////
////  ProfileRelationItemDisplay.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/16.
////
//
//import Foundation
//
//enum ProfileRelationDisplayType {
//    case none
//    case friends(des: String)
//    case closeFriend(des: String)
//}
//
//extension ProfileRelationDisplayType {
//    var title: String {
//        switch self {
//        case .none:
//            return "None"
//        case .friends:
//            return "Friends "
//        case .closeFriend:
//            return "Close Friend"
//        }
//    }
//    
//    var subtitle: String? {
//        switch self {
//        case .none:
//            return nil
//        case .friends(let des):
//            return des
//        case .closeFriend(let des):
//            return des
//        }
//    }
//    
//    var icon: String? {
//        switch self {
//        case .none:
//            return nil
//        case .friends:
//            return "🤝"
//        case .closeFriend:
//            return "🙌"
//        }
//    }
//    
//}
