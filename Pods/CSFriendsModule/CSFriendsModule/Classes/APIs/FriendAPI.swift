//
//  FriendAPI.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/4/3.
//

import Moya
import CSUtilities
import CSAccountManager
import CSNetwork

enum FriendService {
    case friends
    case inviteFriends
    case inviteFieldFriends(name: String)
    case search(name: String)
    case addSearch(name: String)
    case invite(id: UInt, type: String)
    case dealInvitation(id: UInt, type: String, accept: Bool)
    case hiddenUsers
    case connectRequest
    case searchHiddenUsers(key: String)
    case inviteJoinField(uid: Int)
    case recoverHiddenUsers(id: UInt)
    case action(url: String)
    
}

extension FriendService: TargetType, NetworkFullUrl {
    
    var fullUrl: String? {
        switch self {
        case .action(let url):
            let url = "\(Constants.Server.baseURL)/api/v0/\(url)"
            return url
        default:
            return nil
        }
    }
    
    var baseURL: URL {
        return URL(string: Constants.Server.baseURL)!
    }
    var path: String {
        switch self {
        case .friends:
            return "/api/v0/friends"
        case .search:
            return "/api/v0/search_user"
        case .invite:
            return "/api/v0/invite_friendship"
        case .dealInvitation:
            return "/api/v0/deal_friendship_invitation"
        case .inviteFriends:
            return "/api/v0/invite_friends"
        case .inviteFieldFriends:
            return "/api/v0/invite_friends_to_field"
        case .hiddenUsers:
            return "/api/v0/hidden_users"
        case .searchHiddenUsers:
            return "/api/v0/search_hidden_users"
        case .recoverHiddenUsers:
            return "/api/v0/recover_hidden_user"
        case .addSearch:
            return "/api/v0/add_user"
        case .action:
            return ""
        case .connectRequest:
            return "/api/v0/connect_request"
        case .inviteJoinField:
            return "/api/v0/invite_join_field"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .friends, .search, .inviteFriends, .hiddenUsers, .searchHiddenUsers, .addSearch, .action, .connectRequest, .inviteFieldFriends:
            return .get
        case .invite, .dealInvitation, .recoverHiddenUsers, .inviteJoinField:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .friends, .inviteFriends, .hiddenUsers, .action, .connectRequest :
            return .requestPlain
        case .inviteFieldFriends(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case .addSearch(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case .search(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case let .invite(id, type):
            let id = MultipartFormData(provider: .data((String(id)).data(using: .utf8)!), name: "target_id")
            let type = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "friendship_type")
            return .uploadMultipart([id, type])
        case let .dealInvitation(id, type, accept):
            let id = MultipartFormData(provider: .data((String(id)).data(using: .utf8)!), name: "target_id")
            let type = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "friendship_type")
            let accept = MultipartFormData(provider: .data((accept ? "accept" : "reject").data(using: .utf8)!), name: "op")
            return .uploadMultipart([id, type, accept])
        case .searchHiddenUsers(key: let key):
            return .requestParameters(parameters: ["key": key], encoding: URLEncoding.default)
        case .recoverHiddenUsers(id: let id):
            let id = MultipartFormData(provider: .data((String(id)).data(using: .utf8)!), name: "target_id")
            return .uploadMultipart([id])
        case .inviteJoinField(uid: let uid):
            let id = MultipartFormData(provider: .data((String(uid)).data(using: .utf8)!), name: "target_id")
            return .uploadMultipart([id])

        }
    }
    
    var sampleData: Data {
        
        //        let friends = "{\"data\":{\"close_friends\":[{\"id\":1,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"close\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Arthur\",\"system_name\":\"cathy\",\"is_online\":true,\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":2,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"close\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Lydia\",\"system_name\":\"cathy\",\"current_cs_field_name\":\"Lydia‘s Field\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}}],\"friends\":[{\"id\":3,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"good\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Emily\",\"is_online\":true,\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":4,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"good\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Jackie\",\"system_name\":\"cathy\",\"current_cs_field_name\":\"Jackie‘s Field\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}}],\"all\":[{\"id\":1,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"close\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Arthur\",\"system_name\":\"cathy\",\"is_online\":true,\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":2,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"close\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Lydia\",\"system_name\":\"cathy\",\"current_cs_field_name\":\"Lydia‘s Field\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":3,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"good\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Emily\",\"is_online\":true,\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":4,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"good\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Jackie\",\"system_name\":\"cathy\",\"current_cs_field_name\":\"Jackie‘s Field\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":1,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Calvin\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":2,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Elise\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":3,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Ella\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":4,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Eric\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":1,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Harry\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":2,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Ion\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":3,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Lucas\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":4,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Lucy\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}},{\"id\":1,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Mellisa\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"is_online\":true,\"role\":\"client\",\"edges\":{}}}},{\"id\":2,\"create_time\":\"2023-05-25T10:33:30Z\",\"update_time\":\"2023-05-26T01:59:09Z\",\"status\":\"established\",\"request_type\":\"normal\",\"curr_type\":\"normal\",\"user_id\":1,\"friend_id\":4,\"edges\":{\"user\":{\"id\":1,\"create_time\":\"2023-05-23T02:25:09Z\",\"update_time\":\"2023-05-23T02:25:09Z\",\"name\":\"Yongxi\",\"system_name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}}}]},\"status\":200}"
        //
        switch self {
            //        case .friends:
            //            return friends.data(using: .utf8) ?? Data()
        default:
            return Data()
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
