//
//  Message.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/29.
//

import Foundation




public struct Message {
    
    public var wait: String = "";
    /* The Namespace that this message sent to. */
    public var namespace: String = "";
    /* The Room that this message sent to. */
    public var room: String = "";
    /* The Event that this message sent to. */
    public var event: String = "";
    /* The actual body of the incoming data. */
    public var body: WSData = "";
    
    
    /* The Err contains any message's error if defined and not empty.
     server-side and client-side can return an error instead of a message from inside event callbacks. */
    var err: MessageError?
    
    var isError: Bool = false;
    var isNoOp: Bool = false;
    
    let isInvalid: Bool;
    /* The IsForced if true then it means that this is not an incoming action but a force action.
     For example when websocket connection lost from remote the OnNamespaceDisconnect `Message.IsForced` will be true */
    var isForced: Bool = false;
    /* The IsLocal reprots whether an event is sent by the client-side itself, i.e when `connect` call on `OnNamespaceConnect` event the `Message.IsLocal` will be true,
     server-side can force-connect a client to connect to a namespace as well in this case the `IsLocal` will be false. */
    var isLocal: Bool = false;
    /* The IsNative reports whether the Message is websocket native messages, only Body is filled. */
    var isNative: Bool = false;
    
    /* The SetBinary can be filled to true if the client must send this message using the Binary format message. */
    let setBinary: Bool = false; // 暂时不支持这个data 特性
    
    
    var isConnect: Bool {
        return Event(rawValue: event) == .OnNamespaceConnect
    }
    
    var isDisconnect: Bool {
        return Event(rawValue: event) == .OnNamespaceDisconnect
    }
    
    
    var isRoomJoin: Bool {
        return Event(rawValue: event) == .OnRoomJoin
    }
    
    
    var isRoomLeft: Bool {
        return Event(rawValue: event) == .OnRoomLeft
    }
    
    var isWait: Bool {
        if wait.isEmpty {
            return false
        }
        guard let prefix = wait.first else {
            return false
        }
        
        if prefix == MD.waitIsConfirmationPrefix { return true }
        if prefix == MD.waitComesFromClientPrefix { return true }
        return false
    }
    
    /* unmarshal method returns this Message's `Body` as an object,
     equivalent to the Go's `neffos.Message.Unmarshal` method.
     It can be used inside an event's callbacks.
     See library-level `marshal` function too. */
    func unmarshal() -> Any? {
        guard let jsonData = body.data(using: .utf8) else { return nil }
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        return json
    }
    
    
    func serializeMessage() -> WSData {
        if isNative && wait.isEmpty {
            return body
        }
        
        let isErrorString = MD.falseString
        var isNoOpString = MD.falseString
        var body = self.body
    
        if let error = err {
            body = error.message
            // TODO: ???
//            if (!isReply(msg.Err)) {
//                isErrorString = trueString;
//            }
        }
        if isNoOp {
            isNoOpString = MD.trueString
        }
        
        let data = [
            wait,
            Utilities.escapeMessageField(namespace),
            Utilities.escapeMessageField(room),
            Utilities.escapeMessageField(event),
            isErrorString,
            isNoOpString,
            body
        ].joined(separator: String(MD.messageSeparator))
        
        return data
    }
    
    init() {
        isInvalid = false
    }
    
    init(data: String, allowNativeMessages: Bool) {
        guard !data.isEmpty else {
            isInvalid = true
            return
        }
        
        let dts = Utilities.splitN(s: data, sep: MD.messageSeparator, limit: MD.validMessageSepCount)
        if dts.count != MD.validMessageSepCount {
            if !allowNativeMessages {
                isInvalid = true
            } else {
                isInvalid = false
                event = Event.OnNativeMessage.rawValue
                body = data
            }
            return
        }
        wait = dts[0]
        namespace = Utilities.unescapeMessageField(dts[1])
        room = Utilities.unescapeMessageField(dts[2])
        event = Utilities.unescapeMessageField(dts[3])
        isError = dts[4] == MD.trueString
        isNoOp = dts[5] == MD.trueString
        
        if isError {
            err = .serve(dts[6])
        } else {
            body = dts[6]
        }
        
        isInvalid = false
        isNative = allowNativeMessages && (event == Event.OnNativeMessage.rawValue)
        
    }
  
    /*
     
     
     */
}
