//
//  FileKitConfig.swift
//  CSFileKit
//
//  Created by 于冬冬 on 2023/3/14.
//

import Foundation
import FileKit
import CommonCrypto

public struct FileKitConfig {
    public static var uploadUrl: URL?
    
//    public static var tmpPath = Path.userTemporary
}

extension Path {
    
    static var tmpPath: Path {
        return userTemporary + "cs.tmp"
    }
    
    static var tmpImage: Path {
        return tmpPath + "image"
    }
    
//    static var cards: Path {
//        return
//    }
    
}


