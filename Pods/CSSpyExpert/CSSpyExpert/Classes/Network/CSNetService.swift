//
//  CSNetService.swift
//  ComeSocialDemo
//
//  Created by fuhao on 2022/10/10.
//

import Foundation
import Alamofire
import CSUtilities

struct EdgesMode : Codable {
    
}

struct SomeData  : Codable {
    var id: Int?
    var create_time: String?
    var update_time: String?
    var raw_data: [String]?
    var speechs: String?
    var place: String?
    var generated_content: String?
    var status: String?
    var type: String?
    var user_id: Int?
    var edges: EdgesMode?
}

struct NetWorkResult<Element : Codable> : Codable {
    var status: Int?
    var data: Element?
}

struct NetWorkResult2 : Codable {
    var status: Int?
}



class CSNetService {
    private static let DomainURL: String = Constants.Server.baseURL
    private static let lifeFlowDomain = "/api/v0/timedew"

    
    //推送生活流数据
    static func pushLifeFlow(data: UserPushInfoModel, closure: @escaping (_ result:  Bool?) -> Void) {
        var dataJson: String
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(data)
            dataJson = String(data: jsonData, encoding: .utf8)!
        }catch{
            closure(nil)
            return
        }
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let formattedDate = dateFormatter.string(from: date)
//        print("=======   \(formattedDate)  发送生活流数据:\(dataJson)")
        let params: Parameters = ["data":dataJson]
        do {
            let url = URL(string: DomainURL + lifeFlowDomain)!
            var urlRequest = try URLRequest(url: url, method: .post)
            let dataString = "{\"data\": \(dataJson) }"
            urlRequest.httpBody = dataString.data(using: .utf8)!
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
            AF.request(urlRequest).responseDecodable { (response: AFDataResponse<NetWorkResult2>) in
                switch response.result {
                case .success(let model):
                    closure(model.status == 200)
                    break
                case .failure(let error):
                    print(error)
                    closure(nil)
                    break
                }
            }
        } catch {
            // No-op
            closure(nil)
        }

        
        
        

    }
    
    
    
}
