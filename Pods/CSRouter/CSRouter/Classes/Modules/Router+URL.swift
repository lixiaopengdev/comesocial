//
//  Router+URL.swift
//  CSRouter
//
//  Created by 于冬冬 on 2023/5/15.
//

import Foundation
import CSUtilities

public extension Router {
    
    enum Live {
        
        public static let homeRegister = "comesocial://live/home"
        public static let editSaveTimeDewHandleRegister = "comesocial://live/handle/save"
        public static let shareTimeDewRegister = "comesocial://live/handle/share"
        public static let doReactionTimeDewRegister = "comesocial://live/handle/reaction"
        public static let timeDewMoreFunctionRegister = "comesocial://live/handle/more"
        public static let jumpFieldTimeDewRegister = "comesocial://live/handle/jumpfield"
        public static let inviteJoinFieldRegister = "comesocial://live/handle/inviteJoinField"
        
        public static func homePath() -> String {
            return homeRegister
        }
        
        public static func editlSaveTimeDewHandlePath(id: Int, type: String, edit: Int) -> String {
            return editSaveTimeDewHandleRegister + "?id=\(id)&type=\(type)&edit=\(edit)"
        }
        
        public static func timeDewMoreFunctionPath(requestSessionId: String, timeDewId: UInt, timeDewType: String?, isSaveTimeDew: String?) -> String {
            var path = timeDewMoreFunctionRegister + "?requestSessionId=\(requestSessionId)&timeDewId=\(timeDewId)"
            if let timeDewType = timeDewType {
                path = path + "&timeDewType=\(timeDewType)"
            }else{
                path = path + "&timeDewType=system"
            }
            if let isSaveTimeDew = isSaveTimeDew {
                path = path + "&isSaveTimeDew=\(isSaveTimeDew)"
            }
            return path
        }
        
        public static func doReactionTimeDewPath(id: Int, type: String, edit: Int) -> String {
            return doReactionTimeDewRegister + "?id=\(id)&type=\(type)&edit=\(edit)"
        }
        
        public static func jumpFieldTimeDewPath(fieldId: UInt) -> String {
            return jumpFieldTimeDewRegister + "?fieldId=\(fieldId)"
        }
        
        public static func shareTimeDewPath(titleText: String, contentText: String, photoImageURL: String?, contentImageURL: String? = nil) -> String {
            var para = ["titleText": titleText, "contentText": contentText]
            if let photoImageURL = photoImageURL {
                para["photoImageURL"] = photoImageURL
            }
            if let contentImageURL = contentImageURL {
                para["contentImageURL"] = contentImageURL
            }
            var url = URL(string: shareTimeDewRegister)!
            url.appendQueryParameters(para)
            return url.absoluteString
        }
        
        public static func inviteJoinFieldPath(inviteUserId: UInt) -> String {
            return inviteJoinFieldRegister + "?inviteUserId=\(inviteUserId)"
        }
    }
    
    
    enum Friend {
        
        public static func homePath() -> String {
            return homeRegister
        }
        
        public static func hiddenUserPath() -> String {
            return hiddenUserRegister
        }
        
        public static func inviteToFieldPath() -> String {
            return inviteToFieldRegister
        }
        
        public static func connectRequestPath() -> String {
            return connectRequestRegister
        }
        
        public static let homeRegister = "comesocial://friend/home"
        public static let hiddenUserRegister = "comesocial://friend/hidden"
        public static let inviteToFieldRegister = "comesocial://friend/inviteToField"
        public static let connectRequestRegister = "comesocial://friend/connectRequest"
        
    }
    
    enum Me {
        
        private static let profileDomain = "comesocial://me/profile/"
        private static let webDomain = "comesocial://me/web/"
        
        public static func homePath() -> String {
            return homeRegister
        }
        
        public static func profilePath(uid: UInt) -> String {
            return profileDomain + "\(uid)"
        }
        
        public static func webPath(url: String) -> String {
            return webDomain + url
        }
        
        public static let homeRegister = "comesocial://me/home"
        public static let profileRegister = profileDomain + "<uid>"
        public static let webRegister = webDomain + "<url>"
        
    }
    
    enum Field {
        
        private static let userDomain = "comesocial://field/user/"
        private static let fieldDomain = "comesocial://field/field/"
        
        
        public static func listPath() -> String {
            return listRegister
        }
        public static func userPath(uid: UInt) -> String {
            return userDomain + "\(uid)"
        }
        public static func fieldPath(id: UInt) -> String {
            return fieldDomain + "\(id)"
        }
        
        public static func myFieldPath() -> String {
            return myFieldRegister
        }
        public static let listRegister = "comesocial://field/List"
        public static let userRegister = userDomain + "<uid>"
        public static let fieldRegister = fieldDomain + "<id>"
        public static let myFieldRegister = "comesocial://field/field/my"
        
    }
}
