//
//  DownloadTask.swift
//  CSFileKit
//
//  Created by 于冬冬 on 2023/3/9.
//

import Foundation
import Alamofire
import FileKit
import SSZipArchive

public struct CardFile {
    let url: URL
    let file: Path
    
    public init(url: URL) {
        self.url = url
        file = Path.userDocuments + "cards" + url.absoluteString.md5
    }
    
    public var jsFile: String {
       let jsF = js.first { path in
           return path.pathExtension == "js"
        }
        return jsF!.standardRawValue
    }
    
    public var jsDirectory: String {
        return js.standardRawValue
    }
    
    
    var js: Path {
        return file + "js"
    }
    
    var zip: Path {
        return file + "zip.zip"
    }
    
    var flag: Path {
        return file + "flag"
    }

    var isCompleted: Bool {
        return flag.exists
    }
    
//    public func load() {
//        Task {
//
//            try await loadCard()
//        }
//    }
    
    public func loadCard() async throws -> CardFile {
        if isCompleted {
            return self
        }
        try js.createDirectory()
        let zipUrl = try await AF.download(url, to: { temporaryURL, response in
            return (zip.url, [.createIntermediateDirectories, .removePreviousFile])
        }).serializingDownloadedFileURL().value
        guard let zipPath = Path(url: zipUrl) else { throw FileError.download("download error") }
        let success = SSZipArchive.unzipFile(atPath: zipPath.standardRawValue, toDestination: js.standardRawValue)
        if !success {
            throw FileError.download("unzip error")
        }
        try Data().write(to: flag)
        return self
    }
}

public struct DownloadTask {
    


}
 
