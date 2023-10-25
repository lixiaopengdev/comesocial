//
//  SocketStatus.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/29.
//

import Foundation

enum SocketError: Error {
    case server(String, UInt16)
    case cancelled
    case error(Error?)
}
