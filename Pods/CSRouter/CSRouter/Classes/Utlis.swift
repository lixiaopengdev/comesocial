//
//  Utlis.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/6/16.
//

import Foundation

extension URL {
    
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }
    
    mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }

}
