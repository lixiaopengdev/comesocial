////
////  ProfileUserViewModel.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/23.
////
//
//import Foundation
//
//struct ProfileUserViewModel: ProfileUserData {
//    
//    let userModel: UserModel
//    
//    init(userModel: UserModel) {
//        self.userModel = userModel
//    }
//    
//    var name: String {
//        return userModel.name
//    }
//
//    var online: Bool {
//       return false
//    }
//    
//    var action: ProfileView.HeaderAction? {
//        if userModel.status != .multi { return nil }
//        return .disable("In Field now...", nil)
//    }
//    
//    var avatar: String? {
//        return userModel.thumbnailUrl
//    }
//    
//    var subName: String? {
//        let subName = userModel.systemName
//        return "@\(subName) · \(userModel.totalConnections) connections"
//    }
//    
//    var labels: [String] {
//        var labels = [String]()
//        if let school = userModel.schoolName {
//            labels.append(school)
//        }
//        if let constellation = userModel.constellation {
//            labels.append(constellation)
//        }
//        return labels
//    }
//    
//    var bio: String? {
//        return userModel.bio
//    }
//    
//}
//
//struct OtherProfileUserViewModel: ProfileUserData {
//    
//    let userModel: UserModel
//    
//    init(userModel: UserModel) {
//        self.userModel = userModel
//    }
//    
//    var name: String {
//        return userModel.name
//    }
//
//    var online: Bool {
//        return userModel.isOnline ?? false
//    }
//    
//    var action: ProfileView.HeaderAction? {
//        if userModel.isWating {
//            return .disable("Waiting for Response...", UIImage.bundleImage(named: "button_icon_add_friends"))
//        }
//        if userModel.relation == .none {
//            return .enable("Build Connection", UIImage.bundleImage(named: "button_icon_add_friends"))
//        }
//        if userModel.currentFieldId != nil {
//            return .enable("In \(userModel.currentFieldName ?? "Field")", UIImage.bundleImage(named: "button_icon_join"))
//        }
//        return nil
//    }
//    
//    var avatar: String? {
//        return userModel.thumbnailUrl
//    }
//    
//    var subName: String? {
//        let subName = userModel.systemName
//        return "@\(subName) · \(userModel.totalConnections) connections"
//    }
//    
//    var labels: [String] {
//        var labels = [String]()
//        if let school = userModel.schoolName {
//            labels.append(school)
//        }
//        if let constellation = userModel.constellation {
//            labels.append(constellation)
//        }
//        return labels
//    }
//    
//    var bio: String? {
//        return userModel.bio
//    }
//    
//}
