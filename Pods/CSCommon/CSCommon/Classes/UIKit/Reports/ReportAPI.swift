//
//  CommonAPI.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/6.
//

import Moya
import CSUtilities

enum ReportService {
    case feedbackItems(type: FeedbackType)
    case feedback(type: FeedbackType, id: String, reason: String)
}

extension ReportService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .feedbackItems:
            return "/api/v0/feedback_items"
        case .feedback:
            return "/api/v0/feedback"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feedbackItems:
            return .get
        case .feedback:
            return .post
        }
    }
    
    var task: Moya.Task {
        
        switch self {
        case .feedbackItems(let type):
            return .requestParameters(parameters: ["feedback_type": type.rawValue], encoding: URLEncoding.default)
        case .feedback(type: let type, id: let id, reason: let reason):
            let type = MultipartFormData(provider: .data(type.rawValue.data(using: .utf8)!), name: "feedback_type")
            let id = MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "item_id")
            let reason = MultipartFormData(provider: .data(reason.data(using: .utf8)!), name: "reason")
            return .uploadMultipart([type, id, reason])
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
