//
//  ReactionItem.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/6/5.
//

import Foundation

enum MoreItem {
    case join
    case invite
    case save
    case saved
    case share
    case feedback
    
    var image: UIImage? {
        switch self {
        case .join:
            return UIImage.bundleImage(named: "more_join")
        case .save:
            return UIImage.bundleImage(named: "more_save")
        case .saved:
            return UIImage.bundleImage(named: "more_saved")
        case .share:
            return UIImage.bundleImage(named: "more_share")
        case .feedback:
            return UIImage.bundleImage(named: "more_feedback")
        case .invite:
            return UIImage.bundleImage(named: "more_join")
        }
    }
    
    var title: String {
        switch self {
        case .join:
            return "Join"
        case .save:
            return "Save"
        case .saved:
            return "Saved"
        case .share:
            return "Share"
        case .feedback:
            return "Feedback"
        case .invite:
            return "Invite"
        }
    }
    var color: UIColor {
        if self == .feedback {
            return .cs_warningRed
        }
        return .cs_softWhite2
    }
    
    var height: CGFloat {
        if self == .share {
            return 54
        }
        return 68
    }
}



enum ReactionItem : CaseIterable{
    case lol
    case omg
    case cool
    case nooo
    case damn
    
    var image: UIImage? {
        switch self {
        case .lol:
            return UIImage.bundleImage(named: "reflection_lol")
        case .omg:
            return UIImage.bundleImage(named: "reflection_omg")
        case .cool:
            return UIImage.bundleImage(named: "reflection_cool")
        case .nooo:
            return UIImage.bundleImage(named: "reflection_nooo")
        case .damn:
            return UIImage.bundleImage(named: "reflection_damn")
        }
    }
    
    
//    var label: Int {
//        switch self {
//        case .lol:
//            return 1
//        case .omg:
//            return 2
//        case .cool:
//            return 3
//        case .nooo:
//            return 4
//        case .damn:
//            return 5
//        }
//    }
    
    var type: String {
        switch self {
        case .lol:
            return "LOL"
        case .omg:
            return "OMG"
        case .cool:
            return "Cool"
        case .nooo:
            return "Nooo"
        case .damn:
            return "DAMN"
        }
    }
    
//    public static func getReation(label: Int) -> ReactionItem?{
//        for reaction in ReactionItem.allCases {
//            if reaction.label == label {
//                return reaction
//            }
//        }
//
//        return nil
//    }

}
