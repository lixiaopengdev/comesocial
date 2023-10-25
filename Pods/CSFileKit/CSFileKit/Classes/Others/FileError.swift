//
//  FileError.swift
//  CSFileKit
//
//  Created by 于冬冬 on 2023/3/14.
//

import Foundation

public enum FileError: Error {
    case image(String)
    case download(String)
    case upload(String)
    case system(Error)
}
