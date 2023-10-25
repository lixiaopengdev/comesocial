//
//  RoomClient.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/3/28.
//

import Foundation
import Combine

public class RoomClient {
    private var cancellableSet: Set<AnyCancellable> = []

    private let name: String
    private let nsConn: NamespaceClient
    @Published public var isConnected = false
    private var isRegistered = true
    public var onReceiveError = PassthroughSubject<MessageError, Never>()
    public var onReceiveMessage = PassthroughSubject<Message, Never>()

    init(name: String, nsConn: NamespaceClient) {
        self.name = name
        self.nsConn = nsConn
        nsConn
            .$isConnected
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] connConnected in
                if connConnected {
                    self?.joinRoom()
                } else {
                    self?.leaveRoom()
                }
            }
            .store(in: &cancellableSet)
        
    }
    
   public func logoutRoom() {
        isRegistered = false
        self.leaveRoom()
        nsConn.deleteRoom(name)
    }
    
    func receiveMessage(_ msg: Message) {
        onReceiveMessage.send(msg)
    }
    
    func registerHandler(event: String) -> AnyPublisher<Message, Never> {
        let sub = onReceiveMessage.filter({ $0.event == event }).eraseToAnyPublisher()
        return sub
    }
    
  
    
    @discardableResult
    public func emit(event: String, body: WSData) -> Bool {
        var msg =  Message();
        msg.namespace = nsConn.namespace;
        msg.room = name;
        msg.event = event;
        msg.body = body;
        return nsConn.conn.write(msg);
    }
    
    @discardableResult
    public func ask(event: String, body: WSData, callback: MessageComplectionBlock? = nil) {
        var msg =  Message();
        msg.namespace = nsConn.namespace;
        msg.room = name;
        msg.event = event;
        msg.body = body;
        nsConn.conn.ask(msg, callback: callback);
    }
    
    private func joinRoom() {
        var joinMsg = Message();
        joinMsg.namespace = nsConn.namespace;
        joinMsg.room = name
        joinMsg.event = Event.OnRoomJoin.rawValue;
        joinMsg.isLocal = true
        
        nsConn.conn.ask(joinMsg) { [weak self] result in
            switch result {
            case .success(_):
                self?.isConnected = true
            case .failure(let error):
                self?.isConnected = true
                self?.handleError(error)
            }
        }
        
    }
    
    private func leaveRoom() {
        var msg = Message();
        msg.namespace = nsConn.namespace;
        msg.room = name;
        msg.event = Event.OnRoomLeave.rawValue;
        nsConn.conn.ask(msg, callback: nil)
        isConnected = false
    }
    
    private func handleError(_ error: MessageError) {
        onReceiveError.send(error)
    }
}
