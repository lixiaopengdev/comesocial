//
//  Websocket.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/1/28.
//

//import Starscream
import Combine

typealias MessageObserver = (_ message: String) -> Void
typealias SocketStateObserver = (_ connected: Bool, _ error: SocketError?) -> Void

public class Socket {
    
    var cancellableSet: Set<AnyCancellable> = []
    
    private let ws: WebSocket
    
    private let heartbeat = Heartbeat()
    private let retryWorkItem = RetryWorkItem()
    
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isCanceled: Bool = true
    
    
    var msgObserver: MessageObserver?
    var stateObserver: SocketStateObserver?
    
    
    init(url: String) {
        let encodeUrl = url.urlEncoded
        print(encodeUrl)
        var request = URLRequest(url: URL(string: encodeUrl)!)
        ws = WebSocket(request: request)
        
        ws
            .onEventSubject
            .sink { [weak self] event in
                self?.didReceive(event: event)
            }
            .store(in: &cancellableSet)
        ws
            .onMessageSubject
            .sink { [weak self] message in
                self?.heartbeat.receivePong()
                self?.handleMessage(text: message)
            }
            .store(in: &cancellableSet)
        
        $isConnected
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] connected in
                if !(self?.isCanceled ?? true) {
                    if connected {
                        self?.heartbeat.open()
                        self?.retryWorkItem.close()
                    } else {
                        self?.heartbeat.close()
                        self?.retryWorkItem.open()
                    }
                }
            }
            .store(in: &cancellableSet)
        
        
        heartbeat
            .$isDied
            .removeDuplicates()
            .sink { [weak self] died in
                if died {
                    self?.reconnect()
                }
            }
            .store(in: &cancellableSet)
        
        
        
        retryWorkItem
            .onReconnect
            .sink { [weak self] in
                self?.reconnect()
            }
            .store(in: &cancellableSet)
        
        heartbeat
            .onSendPing
            .sink { [weak self] in
                self?.sendPing()
            }
            .store(in: &cancellableSet)
    }
    
    public func startConnect() {
        isCanceled = false
        connect()
    }
    
    public func cancel() {
        isCanceled = true
        heartbeat.close()
        retryWorkItem.close()
        disconnect()
    }
    
    // MARK:  connect
    private func connect() {
        print("==========\(#function)")
        if isCanceled { return }
        if !isConnected {
            ws.connect()
        }
    }
    
    private func reconnect() {
        print("==========\(#function)")
        if isConnected {
            ws.disconnect()
        }
        ws.connect()
    }
    
    public func disconnect() {
        print("==========\(#function)")
        
        if isConnected {
            ws.disconnect()
        }
    }
    
    deinit {
        heartbeat.close()
        retryWorkItem.close()
    }
    
}

extension Socket {
    
    private func sendPing() {
//        printLog("==== sendPing.......")
        
        ws.sendPing { [weak self] error in
            if error == nil {
                self?.heartbeat.receivePong()
            }
        }
    }
    
    @discardableResult
    public func sendMessage(message: String, completion: ((Error?) -> ())? = nil) -> Bool {
        guard isConnected else{
            return false
        }
        printLog("=== 发送： \(message) ")
        ws.write(string: message) { error in
            completion?(error)
        }
        return true
    }
}

// MARK: - background thread
extension Socket {
    public func didReceive(event: WebSocket.Event) {
        switch event {
        case .connected(_):
            handleStateEvent(connected: true, error: nil)
        case .disconnected(let reason, let code):
            handleStateEvent(connected: false, error: SocketError.server(reason, code))
        case .error(let error):
            handleStateEvent(connected: false, error: SocketError.error(error))
        }
        
    }
    
    func handleStateEvent(connected: Bool, error: SocketError?) {
        
        if isConnected != connected {
            isConnected = connected
            if !isConnected {
                disconnect()
            }
            stateObserver?(isConnected, error)
        }
    }
    
    func handleMessage(text: String) {
        printLog("=== 收到： \(text) ")
        msgObserver?(text)
    }
    
}

