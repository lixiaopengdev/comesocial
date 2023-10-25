////
////  Room.swift
////  CSWebsocket
////
////  Created by 于冬冬 on 2023/1/31.
////
//
//import Foundation
//
//public class Room {
//    /* The conn property refers to the main `Conn` constructed by the `dial` function. */
//    let nsConn: NSConn
//    let name: String
//    
//    init(nsconn: NSConn, name: String) {
//        self.nsConn = nsconn
//        self.name = name
//    }
//    
//    /* The emit method sends a message to the server with its `Message.Namespace` filled to this specific namespace. */
//    @discardableResult
//    public func emit(event: String, body: WSData) -> Bool {
//        var msg =  Message();
//        msg.namespace = nsConn.namespace;
//        msg.room = name;
//        msg.event = event;
//        msg.body = body;
//        return nsConn.conn.write(msg);
//    }
//    
//    @discardableResult
//    public func ask(event: String, body: WSData, callback: MessageComplectionBlock? = nil) {
//        var msg =  Message();
//        msg.namespace = nsConn.namespace;
//        msg.room = name;
//        msg.event = event;
//        msg.body = body;
//        nsConn.conn.ask(msg, callback: callback);
//    }
//    
//    /* The leave method sends a local and server room leave signal `OnRoomLeave`
//       and if succeed it fires the OnRoomLeft` event. */
//    public func leave(callback: ErrorBlock?) {
//        var msg = Message();
//        msg.namespace = nsConn.namespace;
//        msg.room = name;
//        msg.event = Event.OnRoomLeave.rawValue;
//        return nsConn.askRoomLeave(msg, callback: callback);
//    }
//    
//    
//}
