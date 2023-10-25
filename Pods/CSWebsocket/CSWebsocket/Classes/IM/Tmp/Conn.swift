////
////  Conn.swift
////  CSWebsocket
////
////  Created by 于冬冬 on 2023/1/31.
////
//
//import Foundation
//
//public typealias ConnStateChangeObserver = (_ conn: Conn) -> Void
//public typealias ConnErrorObserver = (_ conn: Conn, _ error: MessageError) -> Void
//
///* The Conn class contains the websocket connection and the neffos communication functionality.
//   Its `connect` will return a new `NSConn` instance, each connection can connect to one or more namespaces.
//   Each `NSConn` can join to multiple rooms. */
//
//public class Conn {
//
//    var socket: Socket?;
//     /* If > 0 then this connection is the result of a reconnection,
//        see `wasReconnected()` too. */
////    let reconnectTries: number;
////
//    public private(set) var isAcknowledged: Bool = false;
//    public var stateChangeObserve: ConnStateChangeObserver?
//    public var errorObserve: ConnErrorObserver?
//
//    let allowNativeMessages: Bool = false;
//     /* ID is the generated connection ID from the server-side, all connected namespaces(`NSConn` instances)
//       that belong to that connection have the same ID. It is available immediately after the `dial`. */
//    // 暂时感觉没什么用
//    var id: String = "";
//    var  closed: Bool = false
////    let waitServerConnectNotifiers: Map<string, () => void>;
////
//    var queue: [WSData] = []
//    // TODO: 内存问题，回调后删除
//    var waitingMessages: [String: WaitingMessageFunc] = [:];
//    var namespaces: Namespaces = [:];
//    var connectedNamespaces: [String: NSConn] = [:]
//    let messageQueue = DispatchQueue(label: "message.queue")
//    var isClosed: Bool {
//        return !isAcknowledged && !(socket?.isConnected ?? false)
//    }
//
//    public func connectSocket(url: String) {
//        let socket = Socket(url: url)
//        socket.messageQueue = messageQueue
//        self.socket = socket
//        socket.msgObserver = { [weak self] message in
//            DispatchQueue.main.async {
//                guard let self = self else { return }
//                if let error = self.handle(event: message) {
//                    self.errorObserve?(self, error)
//                }
//            }
//        }
//
//        socket.stateObserver = { [weak self] (action, error) in
//            guard let self = self else { return }
////            print("=== status: \(self.socket?.isConnected)")
//            if self.socket?.isConnected ?? false {
//                self.socket?.sendMessage(message: Ack.ackBinary.rawValue)
//            } else {
//                self.errorObserve?(self, .socket(error?.localizedDescription ?? "unknow"))
//            }
//        }
//        socket.connect()
//    }
//
//    func handle(event: String) -> MessageError? {
//
//        guard isAcknowledged else { // 没有确认conn
//            if let error = handleAck(msg: event) {
//                socket?.disconnect()
//                return error
//            }
//            isAcknowledged = true
//            stateChangeObserve?(self)
//            handleQueue()
//            return nil
//        }
//        return handleMessage(data: event)
//    }
//
//
//    private func handleAck(msg: String) -> MessageError? {
//        guard let type = msg.first else{
//            return .serve("empty data")
//        }
//        let typeS = String(type)
//        switch typeS {
//        case Ack.ackIDBinary.rawValue:
//            let id = msg.suffix(from: msg.index(after: msg.startIndex))
//            self.id = String(id)
//        case Ack.ackNotOKBinary.rawValue:
//            // TODO: ack type ???
//            return .serve(msg)
//        default:
//            queue.append(msg)
//        }
//        return nil
//    }
//
//    private func handleQueue() {
//
//        while !queue.isEmpty {
//           let message = queue.removeFirst()
//            handleMessage(data: message)
//        }
//    }
//
//    @discardableResult
//    func handleMessage(data: String) -> MessageError? {
//        var msg = Message(data: data, allowNativeMessages: allowNativeMessages)
//
//        if msg.isInvalid {
//            return .invalidPayload
//        }
//
//        if msg.isNative && allowNativeMessages {
//            let ns = getNamespace("")
//            ns?.fireEvent(msg: msg)
//            return nil
//        }
//
//        if msg.isWait {
//            if let callback = waitingMessages[msg.wait] {
//                callback(msg)
//                return nil
//            }
//        }
//
//        let ns = getNamespace(msg.namespace)
//
//        switch msg.event {
//        case Event.OnNamespaceConnect.rawValue:
//            replyConnect(msg)
//        case Event.OnNamespaceDisconnect.rawValue:
//            replyDisconnect(msg)
//        case Event.OnRoomJoin.rawValue:
//            ns?.replyRoomJoin(msg: msg)
//        case Event.OnRoomLeave.rawValue:
//            ns?.replyRoomLeave(msg: msg)
//        default:
//            guard let ns = ns else { return .badNamespace }
//            msg.isLocal = false
//            if let error = ns.fireEvent(msg: msg) {
//                // write any error back to the server.
//                msg.err = error
//                write(msg)
//                return error
//            }
//
//        }
//        return nil
//    }
//
//    /* The connect method returns a new connected to the specific "namespace" `NSConn` instance or an error. */
//   public func connect(namespace: String, callback: NSConnComplectionBlock?) {
//        askConnect(namespace: namespace, callback: callback);
//    }
//
//    /* waitServerConnect method blocks until server manually calls the connection's `Connect`
//          on the `Server#OnConnected` event. */
//    func waitServerConnect(namespace: String, callback: NSConnComplectionBlock){
//
//    }
//
//
//    func replyConnect(_ msg: Message) {
//        var msg = msg
//        if msg.wait.isEmpty || msg.isNoOp {
//            return
//        }
//        if getNamespace(msg.namespace) != nil { // ns 已经连接了
//
//            writeEmptyReply(msg.wait)
//            return
//        }
//
//        guard let events = getEvents(namespace: msg.namespace) else {
//            msg.err = .badNamespace
//            write(msg)
//            return
//        }
//
//        let ns = NSConn(conn: self, namespace: msg.namespace, events: events)
//        connectedNamespaces[msg.namespace] = ns
//        writeEmptyReply(msg.wait)
//
//        msg.event = Event.OnNamespaceConnected.rawValue
//        ns.fireEvent(msg: msg)
//    }
//
//    func replyDisconnect(_ msg: Message) {
//        if msg.wait.isEmpty || msg.isNoOp {
//            return
//        }
//        guard let ns = getNamespace(msg.namespace) else{
//            writeEmptyReply(msg.wait)
//            return
//        }
//        ns.forceLeaveAll(isLocal: true)
//        connectedNamespaces.removeValue(forKey: msg.namespace)
//        writeEmptyReply(msg.wait)
//        ns.fireEvent(msg: msg)
//    }
//
//    /* The ask method writes a message to the server and blocks until a response or an error received. */
//
//    func ask(_ msg: Message, callback: MessageComplectionBlock?) {
//        var msg = msg
//        if isClosed {
//            callback?(.failure(.closed))
//            return
//        }
//        msg.wait = genWait()
//
//        waitingMessages[msg.wait] = { receive in
//            if receive.isError {
//                callback?(.failure(receive.err ?? .serve("unknow")))
//            } else {
//                callback?(.success(receive))
//            }
//        }
//        if !write(msg) {
//            callback?(.failure(.write))
//        }
//
//    }
//
//    func askConnect(namespace: String, callback: NSConnComplectionBlock?){
//
//        if let ns = getNamespace(namespace) { // it's already connected.
//            callback?(.success(ns))
//            return
//        }
//        guard let events = getEvents(namespace: namespace) else {
//            callback?(.failure(.badNamespace))
//            return
//        }
//        // this.addConnectProcess(namespace);
//        var connectMessage = Message()
//        connectMessage.namespace = namespace;
//        connectMessage.event = Event.OnNamespaceConnect.rawValue;
//        connectMessage.isLocal = true;
//
//        let ns = NSConn(conn: self, namespace: namespace, events: events)
//        if let err = ns.fireEvent(msg: connectMessage) {
//            callback?(.failure(err))
//            return
//        }
//
//        ask(connectMessage) {[weak self] result in
//            switch result {
//            case .success(_):
//                self?.connectedNamespaces[namespace] = ns
//                connectMessage.event = Event.OnNamespaceConnected.rawValue
//                ns.fireEvent(msg: connectMessage)
//                callback?(.success(ns))
//            case .failure(let error):
//                callback?(.failure(error))
//            }
//        }
//    }
//
//    func askDisconnect(_ msg: Message, callback: ErrorBlock?) {
//        var msg = msg
//        guard let ns = getNamespace(msg.namespace) else {
//            callback?(.badNamespace)
//            return
//        }
//        ask(msg) {[weak self] result in
//            switch result {
//            case .success(_):
//                ns.forceLeaveAll(isLocal: true)
//                self?.connectedNamespaces.removeValue(forKey: msg.namespace)
//                msg.isLocal = true
//                let error = ns.fireEvent(msg: msg)
//                callback?(error)
//            case .failure(let error):
//                callback?(error)
//            }
//        }
//
//    }
//
//
//
//    /* The write method writes a message to the server and reports whether the connection is still available. */
//
//    @discardableResult
//    func write(_ msg: Message) -> Bool {
//        if isClosed { return false }
//        if !msg.isConnect && !msg.isDisconnect {
//            // namespace pre-write check.
//
//            guard let ns = getNamespace(msg.namespace) else {
//                return false
//            }
//            // room per-write check.
//            if !msg.room.isEmpty && !msg.isRoomJoin && !msg.isRoomLeft {
//                if ns.rooms[msg.room] == nil {
//                    return false
//                }
//            }
//
//        }
//
//        socket?.sendMessage(message: msg.serializeMessage())
//        return true
//    }
//
//    func writeEmptyReply(_ wait: String) {
//        socket?.sendMessage(message: genEmptyReplyToWait(wait: wait))
//    }
//
//
//
//    func genEmptyReplyToWait(wait: String) -> String {
//
//        return wait + MD.emptySeparator
//    }
//
//
//    public func getNamespace(_ namespace: String) -> NSConn? {
//        return connectedNamespaces[namespace]
//    }
//
//    func getEvents(namespace: String) -> Events? {
//        return namespaces[namespace]
//    }
//
//    /* The close method will force-disconnect from all connected namespaces and force-leave from all joined rooms
//           and finally will terminate the underline websocket connection. After this method call the `Conn` is not usable anymore, a new `dial` call is required. */
//    func close() {
////        if isClosed { return }
//
//        var disconnectMsg = Message();
//        disconnectMsg.event = Event.OnNamespaceDisconnect.rawValue;
//        disconnectMsg.isForced = true;
//        disconnectMsg.isLocal = true;
//        for (name, ns) in connectedNamespaces {
//            ns.forceLeaveAll(isLocal: true)
//            disconnectMsg.namespace = ns.namespace
//            ns.fireEvent(msg: disconnectMsg)
//            connectedNamespaces.removeValue(forKey: name)
//        }
//
//        waitingMessages.removeAll()
//        closed = true
//        if socket?.isConnected ?? false {
//            socket?.disconnect()
//        }
//    }
//
//    func genWait() -> String {
//       return String(MD.waitComesFromClientPrefix) + String(Date().timeIntervalSince1970 * 1000)
//    }
//
//
//    func regist(namespace: String, events: Events) {
//        namespaces[namespace] = events
//    }
//}
//
//
