//
//  LifeFlowService.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/3/29.
//

import Moya
import CSUtilities
import CSAccountManager

enum LifeFlowService {
    case realTimeState
    case save(id: Int, type: String)
    case cancelSave(id: Int, type: String)
    case addReaction(id: Int, type: String)
    case deleteReaction(id: Int, type: String)
    case feedback(id: Int, reason: String)
    case setting(name: String, value: Int)
    case settings
    case invite_join_field(user_id: UInt)
    case jumpToField(fieldID: Int)
}

extension LifeFlowService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Server.baseURL)!
    }
    var path: String {
        switch self {
        case .realTimeState:
            return "/api/v0/timedew_with_reactions"
        case .save:
            return "/api/v0/collection"
        case .cancelSave(id: let id, type: let type):
            return "api/v0/collection"
        case .addReaction:
            return "/api/v0/timedew_reaction"
        case .deleteReaction(id: let id, type: let type):
//            return String(format: "api/v0/timedew_reaction?timedew_id=%d&reaction=%@", id, type)
            return "api/v0/timedew_reaction"
        case .feedback:
            return "/api/v0/feedback"
        case .setting:
            return "/api/v0/setting"
        case .settings:
            return "api/v0/settings"
        case .invite_join_field:
            return "api/v0/invite_join_field"
        case .jumpToField(fieldID: let fieldID):
            return String(format: "api/v0/csfield/%d", fieldID)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .realTimeState:
            return .get
        case .save:
            return .post
        case .cancelSave:
            return .delete
        case .addReaction:
            return .post
        case .deleteReaction:
            return .delete
        case .feedback:
            return .post
        case .setting:
            return .put
        case .settings:
            return .get
        case .invite_join_field:
            return .post
        case .jumpToField:
            return .get
        }

    }
    
    var task: Moya.Task {
        
        
        switch self {
        case .realTimeState:
            return .requestPlain
            
        case let .save(id, type):
            let idData = MultipartFormData(provider: .data(String(id).data(using: .utf8)!), name: "item_id")
            let typeData = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "time_dew")
            return .uploadMultipart([idData, typeData])
            
        case .addReaction(id: let id, type: let type):
            
            let idData = MultipartFormData(provider: .data(String(id).data(using: .utf8)!), name: "timedew_id")
            let typeData = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "reaction")
            return .uploadMultipart([idData, typeData])
            
        case .deleteReaction(id: let id, type: let type):
            return .requestParameters(parameters: ["timedew_id": id, "reaction": type], encoding: URLEncoding.queryString)
            
        case .cancelSave(id: let id, type: let type):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
            
        case .feedback(id: let id, reason: let reason):
            let idData = MultipartFormData(provider: .data(String(id).data(using: .utf8)!), name: "item_id")
            let typeData = MultipartFormData(provider: .data("time_dew".data(using: .utf8)!), name: "feedback_type")
            let reasonData = MultipartFormData(provider: .data(reason.data(using: .utf8)!), name: "reason")
            return .uploadMultipart([typeData, idData, reasonData])
            
        case .setting(name: let name, value: let value):
            let nameData = MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name")
            let valueData = MultipartFormData(provider: .data(String(value).data(using: .utf8)!), name: "switch_value")
            return .uploadMultipart([nameData, valueData])
            
        case .settings:
            return .requestPlain
            
        case .invite_join_field(user_id: let user_id):
            let targetId = MultipartFormData(provider: .data(String(user_id).data(using: .utf8)!), name: "target_id")
            return .uploadMultipart([targetId])
            
        case .jumpToField:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
