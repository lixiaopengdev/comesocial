//
//  Ack.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/31.
//

import Foundation
enum Ack: String {
    
    case ackBinary = "M"; // see `onopen`, comes from client to server at startup.
    // see `handleAck`.
    case ackIDBinary = "A";// comes from server to client after ackBinary and ready as a prefix, the rest message is the conn's ID.
    case ackNotOKBinary = "H"; // comes from server to client if `Server#OnConnected` errored as a prefix, the rest message is the error text.
}
