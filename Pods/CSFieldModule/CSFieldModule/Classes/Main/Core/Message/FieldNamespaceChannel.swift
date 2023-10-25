////
////  FeildNamespaceChannel.swift
////  Alamofire
////
////  Created by 于冬冬 on 2023/2/13.
////
//
//import CSWebsocket
//
//class FieldNamespaceChannel: NamespaceChannel {
//    
//    var nsConn: NSConn?
//    var roomChannels: [RoomChannel] = []
//    
//    init() {
//        print("FieldNamespaceChannel init")
//    }
//    
//    public var namespace: String {
//        return "default"
//    }
//    
//    public func getEvents() -> Events {
//        return
//        [
//            Event.OnNamespaceConnect.rawValue: OnNamespaceConnect,
//            Event.OnNamespaceConnected.rawValue: OnNamespaceConnected,
//            Event.OnNamespaceDisconnect.rawValue: OnNamespaceDisconnect,
//
//            Event.OnRoomJoin.rawValue: OnRoomJoin,
//            Event.OnRoomJoined.rawValue: OnRoomJoined,
//            Event.OnRoomLeave.rawValue: OnRoomLeave,
//            Event.OnRoomLeft.rawValue: OnRoomLeft,
//
//            Event.OnAnyEvent.rawValue: receiveMessage
//        ]
//    }
//    
//    public func connReady(conn: Conn) {
//        conn.connect(namespace: namespace, callback: {[weak self] result in
//            switch result {
//            case .success(let nsConn):
//                self?.nsconnReady(nsconn: nsConn)
//            case .failure(let error):
//                assertionFailure(error.localizedDescription)
//            }
//        })
//    }
//    
//    func nsconnReady(nsconn: NSConn) {
//        self.nsConn = nsconn
//        for roomChannel in roomChannels {
//            nsconn.joinRoom(roomName: roomChannel.name, callback: { [weak roomChannel] result in
//                switch result {
//                case .success(let room):
//                    roomChannel?.roomReday(room)
//                case .failure(let error):
//                    assertionFailure(error.localizedDescription)
//                }
//            })
//        }
//    }
//    
//    func registRoom(_ roomChannel: RoomChannel) {
//        roomChannels.append(roomChannel)
//        if let nsconn = self.nsConn {
//            nsconn.joinRoom(roomName: roomChannel.name, callback: {[weak roomChannel] result in
//                switch result {
//                case .success(let room):
//                    roomChannel?.roomReday(room)
//                case .failure(let error):
//                    assertionFailure(error.localizedDescription)
//                }
//            })
//        }
//    }
//    
//    func unregistRoom(_ roomChannel: RoomChannel) {
//        roomChannels.removeAll(where: { $0 === roomChannel })
//    }
//    
//    
//    
//    
//    
//    // MARK: -- namespace
//    func OnNamespaceConnect(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        printLog(msg)
//        return nil
//    }
//
//    func OnNamespaceConnected(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        printLog(msg)
//
//        return nil
//    }
//    
//    func OnNamespaceDisconnect(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        printLog(msg)
//        return nil
//    }
//
//    // MARK: -- room
//    func OnRoomJoin(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        printLog(msg)
//        return nil
//    }
//
//    func OnRoomJoined(_ c: NSConn, _ msg: Message)  -> MessageError? {
////        for roomChannel in roomChannels {
////            if roomChannel.name == msg.room {
////                roomChannel.receiveMessage(c, msg)
////                return nil
////            }
////        }
//        return nil
//    }
//
//    func OnRoomLeave(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        printLog(msg)
//        return nil
//    }
//
//    func OnRoomLeft(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        printLog(msg)
//        return nil
//    }
//
//
//    func receiveMessage(_ c: NSConn, _ msg: Message)  -> MessageError? {
//        
////        for roomChannel in roomChannels {
////            if roomChannel.name == msg.room {
////                roomChannel.receiveMessage(c, msg)
////                return nil
////            }
////        }
//        
//        for roomChannel in roomChannels {
//            roomChannel.receiveMessage(c, msg)
//        }
//        
//        print(msg)
//        return nil
//    }
//    
//    deinit {
//        print("FieldNamespaceChannel deinit")
//    }
//
//}
