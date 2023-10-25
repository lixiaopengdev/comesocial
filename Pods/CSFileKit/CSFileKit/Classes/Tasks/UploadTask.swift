//
//  UploadTask.swift
//  CSFileKit
//
//  Created by 于冬冬 on 2023/3/9.
//

import Foundation
import Alamofire

public struct UploadTask {
    
    struct FileData: Decodable {
        var urls: [String]
        var mainUrl: String? {
            return urls.first
        }
        
        enum CodingKeys: String, CodingKey {
            case urls = "file_urls"
            case data = "data"
            case status = "status"
            case errCode = "err_code"
            case errMsg = "err_msg"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<UploadTask.FileData.CodingKeys> = try decoder.container(keyedBy: UploadTask.FileData.CodingKeys.self)
            let status = try container.decode(Int.self, forKey: .status)
            guard status == 200 else {
                let errorCode = (try? container.decode(Int.self, forKey: .status)) ?? -1
                let errorMsg = (try? container.decode(String.self, forKey: .status)) ?? "unknow"
                throw FileError.upload("\(errorCode): \(errorMsg)")
            }
            let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
            
            urls = try dataContainer.decode([String].self, forKey: .urls)
        }
    }
    
    public static func uploadImage(path: URL) async throws -> String {
        guard let uploadUrl = FileKitConfig.uploadUrl else {
            throw FileError.upload("uploadUrl is nil")
        }
        let fileData = try await AF.upload(multipartFormData: { form in
            form.append(path, withName: "upload")
            form.append("image".data(using: .utf8)!, withName: "type")
        }, to: uploadUrl).serializingDecodable(FileData.self).value
        guard let firstUrl = fileData.mainUrl else {
            throw FileError.upload("firstUrl is nil")
        }
        return firstUrl
    }
    
    public static func uploadAudio(path: URL) async throws -> String {
        guard let uploadUrl = FileKitConfig.uploadUrl else {
            throw FileError.upload("uploadUrl is nil")
        }
        let fileData = try await AF.upload(multipartFormData: { form in
            form.append(path, withName: "upload")
            form.append("audio".data(using: .utf8)!, withName: "type")
        }, to: uploadUrl).serializingDecodable(FileData.self).value
        guard let firstUrl = fileData.mainUrl else {
            throw FileError.upload("firstUrl is nil")
        }
        return firstUrl
    }
    
    public static func uploadAvatar(from: URL, to: URL) async throws -> String {

        let fileData = try await AF.upload(multipartFormData: { form in
            form.append(from, withName: "upload")
            form.append("image".data(using: .utf8)!, withName: "type")
        }, to: to).serializingDecodable(FileData.self).value
        guard let firstUrl = fileData.mainUrl else {
            throw FileError.upload("firstUrl is nil")
        }
        return firstUrl
    }
    
}
