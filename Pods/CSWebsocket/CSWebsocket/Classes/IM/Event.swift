//
//  Event.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/30.
//

import Foundation

///* The WSData is just a string type alias. */
//type WSData = string;

public enum Event: String {
    /* The OnNamespaceConnect is the event name that it's fired on before namespace connect. */
    case OnNamespaceConnect = "_OnNamespaceConnect";
    /* The OnNamespaceConnected is the event name that it's fired on after namespace connect. */
    case OnNamespaceConnected = "_OnNamespaceConnected";
    /* The OnNamespaceDisconnect is the event name that it's fired on namespace disconnected. */
    case OnNamespaceDisconnect = "_OnNamespaceDisconnect";
    /* The OnRoomJoin is the event name that it's fired on before room join. */
    case OnRoomJoin = "_OnRoomJoin";
    /* The OnRoomJoined is the event name that it's fired on after room join. */
    case OnRoomJoined = "_OnRoomJoined";
    /* The OnRoomLeave is the event name that it's fired on before room leave. */
    case OnRoomLeave = "_OnRoomLeave";
    /* The OnRoomLeft is the event name that it's fired on after room leave. */
    case OnRoomLeft = "_OnRoomLeft";
    
    /* The OnAnyEvent is the event name that it's fired, if no incoming event was registered, it's a "wilcard". */
    case OnAnyEvent = "_OnAnyEvent";
//    /* The OnNativeMessage is the event name, which if registered on empty ("") namespace
//       it accepts native messages(Message.Body and Message.IsNative is filled only). */
    case OnNativeMessage = "_OnNativeMessage";
    
    static func isSystemEvent(event: String) -> Bool {
        return Event(rawValue: event) != nil
    }
    
}





