//
//  MessageError.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/2/1.
//

import Foundation

//const ErrInvalidPayload = new Error("invalid payload");
//const ErrBadNamespace = new Error("bad namespace");
//const ErrBadRoom = new Error("bad room");
//const ErrClosed = new Error("use of closed connection");
//const ErrWrite = new Error("write closed");

public enum MessageError: Error {
    case serve(String)
    case socket(String)
    case invalidPayload
    case badNamespace
    case badRoom
    case closed
    case write

    
    var message: String {
        return ""
    }
}
