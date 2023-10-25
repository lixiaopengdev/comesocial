//
//  FieldAPI.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/3.
//


import Moya
import CSUtilities
import CSAccountManager
import CSMediator

enum FieldService {
    case fields
    case field(id: UInt)
    
    case fieldLive(fieldId: UInt)

    case cards
    case rtcToken(fieldId: UInt)
    
    case lifeSteam(text: String, file: URL)

}

extension FieldService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Server.baseURL)!
    }
    var path: String {
        switch self {
        case .fields:
            return "/api/v0/csfields"
        case .cards:
            return "/api/v1/cards"
        case .rtcToken(let fieldId):
            return "/api/v0/rtc/\(fieldId)/1/uid/\(AccountManager.shared.id)"
        case .fieldLive(fieldId: let fieldId):
            return "/api/v0/csfield_live/\(fieldId)"
        case .lifeSteam:
            return "/api/v0/life_stream"
        case .field(id: let id):
            return "/api/v0/csfield/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lifeSteam:
            return .post
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .lifeSteam(text, url):
            let text = MultipartFormData(provider: .data(text.data(using: .utf8)!), name: "text")
            let profileName = Mediator.resolve(MeService.ProfileService.self)?.profile?.name ?? ""

            let name = MultipartFormData(provider: .data(profileName.data(using: .utf8)!), name: "name")
            let image = MultipartFormData(provider: .file(url), name: "upload")
            return .uploadMultipart([text, image, name])
        case .cards:
            return .requestParameters(parameters: ["tk": "neoworld503"], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        let field = "{\"data\":[{\"id\":2,\"create_time\":\"2023-02-03T02:30:27Z\",\"update_time\":\"2023-02-03T02:30:27Z\",\"name\":\"Cathy Pink's Field\",\"status\":\"opening\",\"type\":\"empty\",\"edges\":{\"joined_user\":[{\"id\":1,\"create_time\":\"2023-01-28T02:25:04Z\",\"update_time\":\"2023-01-28T02:25:04Z\",\"name\":\"cathy\",\"thumbnail_url\":\"http://thumbnail_placeholder.neoworld.com\",\"mobile_no\":\"123123123\",\"status\":\"standalone\",\"role\":\"client\",\"edges\":{}}]}}],\"status\":200}"
        
//
//        "http://sagemaker-us-west-2-887392381071.s3.us-west-2.amazonaws.com/images/camera_123.png",
//            "http://sagemaker-us-west-2-887392381071.s3.us-west-2.amazonaws.com/images/chat_123.png",
//            "http://sagemaker-us-west-2-887392381071.s3.us-west-2.amazonaws.com/images/map_123.png"
        
        let cards = "{\"data\":[{\"id\":1,\"create_time\":\"2023-05-29T14:17:52Z\",\"update_time\":\"2023-05-29T14:17:52Z\",\"name\":\"chat\",\"description\":\"chat\",\"status\":\"status1\",\"type\":\"type1\",\"cover\":\"http://sagemaker-us-west-2-887392381071.s3.us-west-2.amazonaws.com/images/chat_123.png\",\"script_url\":\"http://www.nebulaneutron.com:9999/assets/chat.js.zip\",\"edges\":{}},{\"id\":2,\"create_time\":\"2023-05-29T14:18:27Z\",\"update_time\":\"2023-05-29T14:18:27Z\",\"name\":\"photo\",\"description\":\"photo\",\"status\":\"status1\",\"type\":\"type1\",\"cover\":\"http://sagemaker-us-west-2-887392381071.s3.us-west-2.amazonaws.com/images/camera_123.png\",\"script_url\":\"http://www.nebulaneutron.com:9999/assets/live_photo.js.zip\",\"edges\":{}},{\"id\":3,\"create_time\":\"2023-05-29T14:18:42Z\",\"update_time\":\"2023-05-29T14:18:42Z\",\"name\":\"map\",\"description\":\"map\",\"status\":\"status1\",\"type\":\"type1\",\"script_url\":\"http://www.nebulaneutron.com:9999/assets/map.js.zip\",\"cover\":\"http://sagemaker-us-west-2-887392381071.s3.us-west-2.amazonaws.com/images/map_123.png\",\"edges\":{}}],\"status\":200}"
        
        switch self {
        case .fields:
            return field.data(using: .utf8) ?? Data()
        case .cards:
            return cards.data(using: .utf8) ?? Data()
        default:
            return Data()
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
