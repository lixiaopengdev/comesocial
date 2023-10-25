////
////  ProfileViewModel.swift
////  CSRouter
////
////  Created by 于冬冬 on 2023/5/15.
////
//
//import Foundation
//import CSUtilities
//
//enum ProfileViewModel {
//    case header(user: ProfileUserData)
//    case relationShip
//    case collection(open: Bool?, items: [CollectionModel])
//    
//    var count: Int {
//        switch self {
//        case .collection(open: _ ,items: let items):
//            return items.count
//        default:
//            return 1
//        }
//    }
//    
//    var header: ProfileSectionHeaderDisplay? {
//        switch self {
//        case .header:
//            return nil
//        case .relationShip:
//            return AnyProfileSectionHeaderDisplay(title: "Relationship")
//        case .collection(let open, _):
//            if let open = open {
//                let subtitle = open ? "Visible to public" : "Invisible to public"
//                return AnyProfileSectionHeaderDisplay(title: "Collection", subtitle: subtitle, open: open)
//            } else {
//                return AnyProfileSectionHeaderDisplay(title: "Collection")
//            }
//        }
//    }
//    
//    var cellIdentifier: String {
//        switch self {
//        case .header:
//            return ProfileHeaderCell.cellIdentifier
//        case .relationShip:
//            return ProfileRelationshipCell.cellIdentifier
//        case .collection(items: _):
//            return ProfileCollectionCell.cellIdentifier
//        }
//    }
//    
//    func cellHeight(index: Int) -> CGFloat {
//        switch self {
//        case .header(let user):
//            return ProfileHeaderCell.cellHeight(user: user)
//        case .relationShip:
//            return 90
//        case .collection( _, let items):
//            let item = items[index]
//            let contentH: CGFloat = item.content.calculateHeight(width: Device.UI.screenWidth - 18 * 2 - 16 * 2, font: UIFont.regularSubheadline)
//            let imageH: CGFloat = (item.pic == nil ? 0 : 180 + 15)
//            return 59 + contentH + imageH + 10
//            
//        }
//    }
//    
//    var headerHeight: CGFloat {
//        switch self {
//        case .header(_):
//            return 0.001
//        case .relationShip:
//            return 57
//        case .collection(let open, _):
//            if open != nil {
//                return 74
//            } else {
//                return 57
//            }
//        }
//    }
//    
//}
