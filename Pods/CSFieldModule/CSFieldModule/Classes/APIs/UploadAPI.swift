//
//  ImageAPI.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/28.
//

import Moya
import CSUtilities
import CSAccountManager

enum UploadService {
    case upload(file: URL)
}

extension UploadService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .upload:
            return "/upload"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        
        switch self {
        case .upload(let url):
            
            let type = MultipartFormData(provider: .data("image".data(using: .utf8)!), name: "type")
            let image = MultipartFormData(provider: .file(url), name: "upload")
            return .uploadMultipart([type, image])
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
