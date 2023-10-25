//
//  ConnSender.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/3/28.
//

import Foundation
import Combine
import CSUtilities
//import CSConstants

public class ConnectClient {
    
    public static let shared = ConnectClient()

    private let messageQueue = DispatchQueue(label: "message.queue")
    private var allowNativeMessages: Bool = false;
    
    private var id: String = "";
    private var queue: [WSData] = []
    
    private var socket: Socket?
    
    private var namespaceClients: [String: NamespaceClient] = [:]
    private var waitingMessages: [String: WaitingMessageFunc] = [:];
    
    // 发生错误
    public var onReceiveError = PassthroughSubject<MessageError, Never>()
    public var onReceiveNativeMessage = PassthroughSubject<Message, Never>()
    public var onReceiveMessage = PassthroughSubject<Message, Never>()
    
    @Published public private(set) var isConnected: Bool = false
    
    
    public func connect(id: UInt) {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjozMjEzMjF9.8waEX7-vPKACa-Soi1pQvW3Rl8QY-SUFcHKTLZI4mvU"
        //        let url =  Constants.Service.wsURL + "/ws?token=\(token)&X-Websocket-Header-X-Username=\(name)&X-Websocket-Header-X-UserID=\(id)"
        let url =  Constants.Server.wsURL + "/ws?token=\(token)&X-Websocket-Header-X-UserID=\(id)"
        connectSocket(url: url)
    }
    
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    private func connectSocket(url: String, allowNativeMessages: Bool = false) {
        let socket = Socket(url: url)
        self.socket = socket
        socket.msgObserver = { [weak self] message in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = self.handle(event: message) {
                    self.handleError(error)
                }
            }
        }
        
        socket.stateObserver = { [weak self] (action, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let socketConnect = self.socket?.isConnected ?? false
                if socketConnect {
                    self.socket?.sendMessage(message: Ack.ackBinary.rawValue)
                } else {
                    // todo
                    self.isConnected = false
                    self.handleError(.socket(error?.localizedDescription ?? "unknow"))
                }
            }
        }
        socket.startConnect()
    }
    
    func handleError(_ error: MessageError) {
        onReceiveError.send(error)
    }
    
    
    
    func handle(event: String) -> MessageError? {
        
        guard isConnected else { // 没有确认conn
            if let error = handleAck(msg: event) {
                socket?.disconnect()
                return error
            }
            isConnected = true
            handleQueue()
            return nil
        }
        return handleMessage(data: event)
    }
    
    private func handleAck(msg: String) -> MessageError? {
        guard let type = msg.first else {
            return .serve("empty data")
        }
        let typeS = String(type)
        switch typeS {
        case Ack.ackIDBinary.rawValue:
            let id = msg.suffix(from: msg.index(after: msg.startIndex))
            self.id = String(id)
        case Ack.ackNotOKBinary.rawValue:
            return .serve(msg)
        default:
            queue.append(msg)
        }
        return nil
    }
    
    private func handleQueue() {
        
        while !queue.isEmpty {
            let message = queue.removeFirst()
            if let error = handleMessage(data: message) {
                handleError(error)
            }
        }
    }
    
    private func handleMessage(data: String) -> MessageError? {
        var msg = Message(data: data, allowNativeMessages: allowNativeMessages)
        
        if msg.isInvalid {
            return .invalidPayload
        }
        
        if msg.isNative && allowNativeMessages {
            onReceiveNativeMessage.send(msg)
            return nil
        }
        
        if msg.isWait {
            if let callback = waitingMessages.removeValue(forKey: msg.wait) {
                callback(msg)
                return nil
            }
        }
        
        onReceiveMessage.send(msg)
        if let client = namespaceClients[msg.namespace] {
            client.receiveMessage(msg)
        }
        return nil
    }
    
    func ask(_ msg: Message, callback: MessageComplectionBlock?) {
        var msg = msg
        guard isConnected else {
            callback?(.failure(.closed))
            return
        }
        msg.wait = genWait()
        
        waitingMessages[msg.wait] = { receive in
            if receive.isError {
                callback?(.failure(receive.err ?? .serve("unknow")))
            } else {
                callback?(.success(receive))
            }
        }
        if !write(msg) {
            callback?(.failure(.write))
        }
    }
    
    func write(_ msg: Message) -> Bool {
        guard isConnected else { return false }
        guard let socket = socket else { return false }
        let send = socket.sendMessage(message: msg.serializeMessage())
        return send
    }
    
    private func genWait() -> String {
        return String(MD.waitComesFromClientPrefix) + String(Date().timeIntervalSince1970 * 1000)
    }
    
    @discardableResult
    public func registerNamespace(_ namespace: String) -> NamespaceClient {
        if let client = namespaceClients[namespace] {
//            assertionFailure("Namespace Client exist")
            return client
        }
        let client = NamespaceClient(name: namespace, conn: self)
        namespaceClients[namespace] = client
        return client
    }
    
    public func getNamespaceClient(_ namespace: String) -> NamespaceClient {
        if let client = namespaceClients[namespace] {
            return client
        }
//        assertionFailure("Namespace Client empty")
        return registerNamespace(namespace)
    }
    
    func deleteNamespace(_ namespace: String) {
        guard let _ = namespaceClients.removeValue(forKey: namespace) else {
//            assertionFailure("Namespace Client empty")
            return
        }
    }
    
    
    
    func registerHandler(name: String, event: String) -> AnyPublisher<Message, Never> {
        let sub = onReceiveMessage.filter({ $0.namespace == name && $0.event == event}).eraseToAnyPublisher()
        return sub
    }
    
    func registerHandler(name: String) -> AnyPublisher<Message, Never> {
        let sub = onReceiveMessage.filter({ $0.namespace == name }).eraseToAnyPublisher()
        return sub
    }
    
}




