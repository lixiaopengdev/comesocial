////
////  LifeFlowService.swift
////  CSLiveModule
////
////  Created by fuhao on 2023/3/29.
////
//
//
//import CSUtilities
//
//enum LifeFlowService {
//    case pushState(info: UserPushInfoModel)
//}
//
//extension LifeFlowService: TargetType {
//    var baseURL: URL {
//        return URL(string: Constants.Server.baseURL)!
//    }
//    var path: String {
//        switch self {
//        case .pushState:
//            return "/api/v1/lifeFlows"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .pushState:
//            return .post
//        default:
//            return .get
//        }
//    }
//    
//    var task: Moya.Task {
//        switch self {
//        case let .pushState(info):
//            do {
//                let encoder = JSONEncoder()
//                let userData = try encoder.encode(info)
//                print("userData: \(userData)")
//                return .requestJSONEncodable(userData)
//            } catch {
//                
//            }
//            return .requestPlain
//        default:
//            return .requestPlain
//        }
//    }
//    
//    var headers: [String : String]? {
//        return nil
//    }
//    
//    
//}
