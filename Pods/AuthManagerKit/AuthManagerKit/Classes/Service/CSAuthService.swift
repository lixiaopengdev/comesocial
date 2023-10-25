//
//  File.swift
//  AuthManagerKit
//
//  Created by li on 6/2/23.
//

import Foundation
import Moya
import CSUtilities

enum CSAuthService {
    case signin(regionCode:String, mobileNo:String,password:String, type:String)
    case signup(regionCode:String, mobileNo:String, password:String,birthday:String, name:String)
    case checkPhone(regionCode:String ,mobileNo:String)
    case checkPassword(regionCode:String ,mobileNo:String, pw:String)
    case checkBirthday(regionCode:String, mobileNo:String, birthday:String)
    case privacyText
    case privacyConfirm
    case terms
    case privacy
}

extension CSAuthService : TargetType {
    var baseURL: URL {
//        return URL(string: "http://test.zingy.social")!
        return URL(string: Constants.Server.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkPhone:
            return "/api/v0/login_check_mobile"
        case .signin:
            return "/api/v0/signin"
        case .signup:
            return "/api/v0/signup"
        case .checkPassword:
            return "/api/v0/login_check_pw_format"
            
        case .checkBirthday:
            return "/api/v0/login_check_birthday"
        case .privacyText:
            return "/api/v0/privacy_text"
        case .privacyConfirm:
            return "/api/v0/privacy_confirm"
        case .privacy:
            return "/api/v0/terms"
        case .terms:
            return "/api/v0/privacy"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkPhone, .checkPassword, .checkBirthday, .privacyText,.privacy, .terms:
            return .get
        case .signup, .signin, .privacyConfirm:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .checkPhone(regionCode, mobileNo):
            let params = ["region_code":regionCode, "mobile_no":mobileNo]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case let .checkPassword(regionCode, mobileNo, pw):
            let params = ["region_code":regionCode, "mobile_no":mobileNo,"pw":pw]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case let .checkBirthday(regionCode, mobileNo, birthday):
            let params = ["region_code":regionCode, "mobile_no":mobileNo,"birthday":birthday]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)

        case .privacyText, .privacyConfirm, .privacy ,.terms:
            return .requestPlain
        case let .signin(regionCode, mobileNo, password, type):
            
            let mobileNo = MultipartFormData(provider: .data(mobileNo.data(using: .utf8)!), name: "mobile_no")
            let regionCode = MultipartFormData(provider: .data(regionCode.data(using: .utf8)!), name: "region_code")
            let password = MultipartFormData(provider: .data(password.data(using: .utf8)!), name: "password")
            let type = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "type")
            let dict = [mobileNo, regionCode ,password ,type]
            return .uploadMultipart(dict)
        case let .signup(regionCode, mobileNo, password, birthday, name):
            let mobileNo = MultipartFormData(provider: .data(mobileNo.data(using: .utf8)!), name: "mobile_no")
            let regionCode = MultipartFormData(provider: .data(regionCode.data(using: .utf8)!), name: "region_code")
            let password = MultipartFormData(provider: .data(password.data(using: .utf8)!), name: "password")
            let birthday = MultipartFormData(provider: .data(birthday.data(using: .utf8)!), name: "birthday")
            let name = MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name")
            let dict = [regionCode ,mobileNo, password, birthday,name]
            return .uploadMultipart(dict)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
