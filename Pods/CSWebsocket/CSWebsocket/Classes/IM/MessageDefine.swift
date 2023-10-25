//
//  MessageDefine.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/31.
//

import Foundation

public typealias WSData = String

/* The MessageHandlerFunc is the definition type of the events' callback.
   Its error can be written to the other side on specific events,
   i.e on `OnNamespaceConnect` it will abort a remote namespace connection.
   See examples for more. */
//public typealias MessageHandlerFunc = (_ c: NSConn, _ msg: Message) -> MessageError?;
//public typealias Events = Dictionary<String, MessageHandlerFunc>;
//public typealias Namespaces = Dictionary<String, Events>;
public typealias WaitingMessageFunc = (_ msg: Message) -> Void;


public typealias MessageBlock = (_ message: Message) -> Void
public typealias ErrorBlock = (_ error: MessageError?) -> Void
//public typealias RoomBlock = (_ message: Room) -> Void
public typealias MessageComplectionBlock = (_ result: Result<Message, MessageError>) -> Void
//public typealias RoomComplectionBlock = (_ result: Result<Room, MessageError>) -> Void
//public typealias NSConnComplectionBlock = (_ result: Result<NSConn, MessageError>) -> Void



typealias MD = MessageDefine
struct MessageDefine {
    /* Obsiously, the below should match the server's side. */
    static let  messageSeparator: Character = ";";
    static let  emptySeparator: String = ";;;;;;";

    static let   messageFieldSeparatorReplacement = "@%!semicolon@%!";
    static let   validMessageSepCount = 7;
    static let   trueString = "1";
    static let   falseString = "0";
    
    static let   waitIsConfirmationPrefix: Character = "#";
    static let   waitComesFromClientPrefix: Character = "$";
}
