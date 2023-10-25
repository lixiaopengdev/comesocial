//
//  MeAPI.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/23.
//

import Moya
import CSUtilities
import CSAccountManager

protocol SettingServiceParameter {
    var key: String { get }
    var value: String { get }
}

enum UserService {
    case me
    case user(id: UInt)
    case edit(type: MyProfileEditType)
    case avatar(url: URL)
    case openCollection(open: Bool)
    case settings
    case editSettings(para: SettingServiceParameter)
    case collections
    case dupName(name: String)
    case hidden(uid: UInt)
    case delete
    
}

extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .me:
            return "/api/v0/curr_user"
        case .user(id: let id):
            return "/api/v0/user/\(id)"
        case .edit:
            return "/api/v0/user_info"
        case .avatar:
            return "/api/v0/user_thumbnail"
        case .openCollection:
            return "/api/v0/user/collection_switch"
        case .settings:
            return "/api/v0/settings"
        case .editSettings:
            return "/api/v0/setting"
        case .collections:
            return "/api/v0/collections"
        case .dupName:
            return "/api/v0/check_dup_name"
        case .hidden:
            return "/api/v0/hidden_user"
        case .delete:
            return "/api/v0/account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .edit, .openCollection, .editSettings:
            return .put
        case .avatar, .hidden:
            return .post
        case .me, .user, .settings, .collections, .dupName:
            return .get
        case .delete:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .edit(let type):
            let value = MultipartFormData(provider: .data(type.content.data(using: .utf8)!), name: "value")
            let key = MultipartFormData(provider: .data(type.apiKey.data(using: .utf8)!), name: "item_name")

            return .uploadMultipart([key, value])
        case .avatar(let url):
            let image = MultipartFormData(provider: .file(url), name: "upload")
            return .uploadMultipart([image])
        case .me, .user, .settings, .collections, .delete:
            return .requestPlain
        case .openCollection(open: let open):
            let open = MultipartFormData(provider: .data((open ? "1" : "0").data(using: .utf8)!), name: "switch_value")
            return .uploadMultipart([open])
        case .editSettings(let para):
            let open = MultipartFormData(provider: .data((para.value).data(using: .utf8)!), name: para.key)
            return .uploadMultipart([open])
        case .dupName(let name):
            return .requestParameters(parameters: ["user_name": name], encoding: URLEncoding.default)
        case .hidden(uid: let uid):
            let id = MultipartFormData(provider: .data(uid.string.data(using: .utf8)!), name: "target_id")
            return .uploadMultipart([id])
            
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
