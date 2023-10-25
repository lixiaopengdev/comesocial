//
//  MessageUtility.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/2/16.
//

import Foundation

class MessageUtility {
    static func toJson(_ data: Any) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: data)
            guard let string = String(data: data, encoding: .utf8) else {
                assertionFailure("data error" )
                return nil
            }
            return string
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
    static func JsonTo(_ jsonString: String) -> Any? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let value = try? JSONSerialization.jsonObject(with: data)
        return value
    }

}
