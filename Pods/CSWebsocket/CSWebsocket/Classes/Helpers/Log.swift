//
//  Log.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/30.
//

import Foundation

public func printLog(_ msg: Any,
                     file: NSString = #file,
                     line: Int = #line,
                     fn: String = #function) {
#if DEBUG
    let t = String.formatDate(Date(), "yyyy-MM-dd HH:mm:ss.SSSSSS")
    let prefix = "\(t) \(file.lastPathComponent) -> \(fn) [line: \(line)]： \(msg)";
    print(prefix)
#endif
}

#if DEBUG
private extension String {
  static func formatDate(_ date:Date,_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
     }
 }
#endif
