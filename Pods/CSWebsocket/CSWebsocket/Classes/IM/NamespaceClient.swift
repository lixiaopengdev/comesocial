//
//  NamespaceClient.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/3/28.
//

import Foundation
import Combine

public class NamespaceClient {
    
    private var cancellableSet: Set<AnyCancellable> = []
    let namespace: String
    let conn: ConnectClient
    private var roomClients: [String: RoomClient] = [:]
    
    @Published public var isConnected = false
    public var onReceiveError = PassthroughSubject<MessageError, Never>()
    public var onReceiveMessage = PassthroughSubject<Message, Never>()

    init(name: String, conn: ConnectClient) {
        namespace = name
        self.conn = conn
        conn
            .$isConnected
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .filter({ [weak self] in
                $0 != self?.isConnected
            })
            .sink { [weak self] connConnected in
                if connConnected {
                    self?.askConnect()
                } else {
                    self?.askDisconnect()
                }
            }
            .store(in: &cancellableSet)
        
    }
    
    
    public func receiveMessage(_ msg: Message) {
        // TODO: error 暂时没有room标识
//        if let room = roomClients[msg.room] {
//            room.receiveMessage(msg)
//        }
        
        for roomClient in roomClients {
            roomClient.value.receiveMessage(msg)
        }
        onReceiveMessage.send(msg)
    }
    
    func registerHandler(event: String) -> AnyPublisher<Message, Never> {
        let sub = onReceiveMessage.filter({ $0.event == event }).eraseToAnyPublisher()
        return sub
    }
    
    @discardableResult
    public func emit(event: String, body: WSData) -> Bool {
        var msg =  Message();
        msg.namespace = namespace;
        msg.event = event;
        msg.body = body;
        return conn.write(msg);
    }
    
    /* See `Conn.ask`. */
    public func ask(event: String, body: WSData, callback: MessageComplectionBlock?) {
        var msg = Message();
        msg.namespace = namespace;
        msg.event = event;
        msg.body = body;
        return conn.ask(msg, callback: callback)
    }
    
    public func registerRoom(_ name: String) -> RoomClient {
        if let client = roomClients[name] {
            assertionFailure("room Client exist")
            return client
        }
        let client = RoomClient(name: name, nsConn: self)
        roomClients[name] = client
        return client
    }
    
    /// 第一次获取也会加入room
    public func getRoomClient(_ name: String) -> RoomClient {
        if let client = roomClients[name] {
            return client
        }
        assertionFailure("room Client empty")
        return registerRoom(namespace)
    }
    
    func deleteRoom(_ name: String) {
        guard let room = roomClients.removeValue(forKey: name) else {
            assertionFailure("room Client empty")
            return
        }
    }
    
    public func logoutNamespace() {
        askDisconnect()
        conn.deleteNamespace(namespace)
    }
    
    
    
    
    private func askConnect(){
        var connectMessage = Message()
        connectMessage.namespace = namespace;
        connectMessage.event = Event.OnNamespaceConnect.rawValue;
        connectMessage.isLocal = true;
        conn.ask(connectMessage) {[weak self] result in
            switch result {
            case .success(_):
                self?.isConnected = true
            case .failure(let error):
                self?.isConnected = false
                self?.handleError(error)
            }
        }
    }
    
    private func askDisconnect() {
        var disconnectMsg = Message();
        disconnectMsg.namespace = namespace;
        disconnectMsg.event = Event.OnNamespaceDisconnect.rawValue;
        conn.ask(disconnectMsg, callback: nil)
        self.isConnected = false
    }
    
    private func handleError(_ error: MessageError) {
        onReceiveError.send(error)
    }
}
