////
////  NSConn.swift
////  CSWebsocket
////
////  Created by 于冬冬 on 2023/1/31.
////
//
//import Foundation
//
///* The NSConn describes a connected connection to a specific namespace,
//   it emits with the `Message.Namespace` filled and it can join to multiple rooms.
//   A single Conn can be connected to one or more namespaces,
//   each connected namespace is described by this class. */
//public class NSConn {
//
//    let conn: Conn;
//    let namespace: String;
//    let events: Events
//    /* The rooms property its the map of the connected namespace's joined rooms. */
//    var rooms: Dictionary<String, Room> = [:];
//
//    init(conn: Conn, namespace: String, events: Events) {
//        self.conn = conn;
//        self.namespace = namespace;
//        self.events = events;
//    }
//
//    /* The emit method sends a message to the server with its `Message.Namespace` filled to this specific namespace. */
//    @discardableResult
//    public func emit(event: String, body: WSData) -> Bool {
//        var msg =  Message();
//        msg.namespace = namespace;
//        msg.event = event;
//        msg.body = body;
//        return conn.write(msg);
//    }
//
//    /* See `Conn.ask`. */
//    public func ask(event: String, body: WSData, callback: MessageComplectionBlock?) {
//        var msg = Message();
//        msg.namespace = namespace;
//        msg.event = event;
//        msg.body = body;
//        return conn.ask(msg, callback: callback)
//    }
//
//    /* The joinRoom method can be used to join to a specific room, rooms are dynamic.
//       Returns a `Room` or an error. */
//    public func joinRoom(roomName: String, callback: @escaping RoomComplectionBlock) {
//        askRoomJoin(roomName, callback: callback);
//    }
//
//    /* The room method returns a joined `Room`. */
//
//    public func room(roomName: String) -> Room? {
//        return rooms[roomName]
//    }
//
//    /* The leaveAll method sends a leave room signal to all rooms and fires the `OnRoomLeave` and `OnRoomLeft` (if no error occurred) events. */
//    // TODO:  暂时方案，发生错误不会中断
//    public func leaveAll(callback: ErrorBlock?) {
//
//        var leaveMsg = Message();
//        leaveMsg.namespace = namespace;
//        leaveMsg.event =  Event.OnRoomLeft.rawValue;
//        leaveMsg.isLocal = true;
//
//        for (roomName, _) in rooms {
//            leaveMsg.room = roomName
//            askRoomLeave(leaveMsg, callback: callback)
//        }
//
//    }
//
//    public func forceLeaveAll(isLocal: Bool) {
//        var leaveMsg = Message();
//        leaveMsg.namespace = namespace;
//        leaveMsg.isLocal = isLocal;
//        leaveMsg.isForced = true
//
//        for (roomName, _) in rooms {
//            leaveMsg.room = roomName
//
//            leaveMsg.event =  Event.OnRoomLeave.rawValue;
//            fireEvent(msg: leaveMsg)
//
//            rooms.removeValue(forKey: roomName)
//
//            leaveMsg.event = Event.OnRoomLeft.rawValue;
//            fireEvent(msg: leaveMsg)
//
//        }
//    }
//
//    /* The disconnect method sends a disconnect signal to the server and fires the `OnNamespaceDisconnect` event. */
//
//    public func disconnect(callback: ErrorBlock?) {
//        var disconnectMsg = Message();
//        disconnectMsg.namespace = namespace;
//        disconnectMsg.event = Event.OnNamespaceDisconnect.rawValue;
//        conn.askDisconnect(disconnectMsg, callback: callback);
//    }
//
//    public  func askRoomJoin(_ roomName: String, callback: RoomComplectionBlock?) {
//        if let room = rooms[roomName] {
//            callback?(.success(room))
//            return
//        }
//
//        var joinMsg = Message();
//        joinMsg.namespace = namespace;
//        joinMsg.room = roomName
//        joinMsg.event = Event.OnRoomJoin.rawValue;
//        joinMsg.isLocal = true
//
//        func askSuccess() {
//            if let error = fireEvent(msg: joinMsg) {
//                callback?(.failure(error))
//            } else {
//                let room = Room(nsconn: self, name: roomName)
//                rooms[roomName] = room
//
//                joinMsg.event = Event.OnRoomJoined.rawValue
//                fireEvent(msg: joinMsg)
//                callback?(.success(room))
//            }
//
//        }
//
//        conn.ask(joinMsg) { result in
//            switch result {
//            case .success(_):
//                askSuccess()
//            case .failure(let error):
//                callback?(.failure(error))
//            }
//        }
//
//    }
//
//
//    public func askRoomLeave(_ message: Message, callback: ErrorBlock?) {
//        guard let _ = rooms[message.room] else {
//            callback?(.badRoom)
//            return
//        }
//
//        func askSuccess() {
//            var msg = message
//            if let error = fireEvent(msg: msg) {
//                callback?(error)
//            } else {
//                rooms.removeValue(forKey: msg.room)
//                msg.event = Event.OnRoomLeft.rawValue
//                fireEvent(msg: msg)
//            }
//
//        }
//
//        conn.ask(message) { result in
//            switch result {
//            case .success(_):
//                askSuccess()
//            case .failure(let error):
//                callback?(error)
//            }
//        }
//    }
//
//
//    func replyRoomJoin(msg: Message) {
//        var msg = msg
//        if msg.wait.isEmpty || msg.isNoOp {
//            return
//        }
//        if rooms[msg.room] == nil {
//            if let err = fireEvent(msg: msg) {
//                msg.err = err
//                conn.write(msg)
//                return
//            }
//            rooms[msg.room] = Room(nsconn: self, name: msg.room)
//            msg.event = Event.OnRoomJoined.rawValue
//            fireEvent(msg: msg)
//        }
//        conn.writeEmptyReply(msg.wait)
//    }
//
//    func replyRoomLeave(msg: Message) {
//        var msg = msg
//        if msg.wait.isEmpty || msg.isNoOp {
//            return
//        }
//        if rooms[msg.room] == nil {
//            conn.writeEmptyReply(msg.wait)
//            return
//        }
//        fireEvent(msg: msg)
//
//        rooms.removeValue(forKey: msg.room)
//        conn.writeEmptyReply(msg.wait)
//        msg.event = Event.OnRoomLeft.rawValue
//        fireEvent(msg: msg)
//    }
//
//
//
//    @discardableResult
//    func fireEvent(msg: Message) -> MessageError? {
//        if let handle = events[msg.event] {
//            return handle(self, msg)
//        }
//
//        if let handle = events[Event.OnAnyEvent.rawValue] {
//            return handle(self, msg)
//        }
//
//        return nil;
//    }
//
//
//}
