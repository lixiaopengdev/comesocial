//
//  Websocket.swift
//  CSWebsocket
//
//  Created by 于冬冬 on 2023/3/30.
//


import Foundation
import Combine

public class WebSocket: NSObject, URLSessionDataDelegate, URLSessionWebSocketDelegate {
    
    public enum Event {
        case connected([String: String])
        case disconnected(String, UInt16)
        case error(Error?)
    }
    
    private var task: URLSessionWebSocketTask?
    let onMessageSubject = PassthroughSubject<String, Never>()
    let onEventSubject = PassthroughSubject<Event, Never>()
    
    public var request: URLRequest

    public init(request: URLRequest) {
        self.request = request
    }
    
    public func connect() {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        task = session.webSocketTask(with: request)
        doRead()
        task?.resume()
    }

    public func disconnect(closeCode: UInt16 = 1000) {
        let closeCode = URLSessionWebSocketTask.CloseCode(rawValue: Int(closeCode)) ?? .normalClosure
        task?.cancel(with: closeCode, reason: nil)
    }

    public func forceDisconnect() {
        disconnect(closeCode: UInt16(URLSessionWebSocketTask.CloseCode.abnormalClosure.rawValue))
    }

    public func write(string: String, completion: @escaping ((Error?) -> ())) {
        task?.send(.string(string), completionHandler: completion)
    }
    
    public func sendPing(completion: @escaping ((Error?) -> ())) {
        task?.sendPing(pongReceiveHandler: completion)
    }

    private func doRead() {
        task?.receive { [weak self] (result) in
            switch result {
            case .success(let message):
                switch message {
                case .string(let string):
                    self?.onMessageSubject.send(string)
                case .data(let data):
                    assertionFailure("data.count")
                    break
                @unknown default:
                    break
                }
                break
            case .failure(let error):
                self?.onEventSubject.send(.error(error))
            }
            self?.doRead()
        }
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        let p = `protocol` ?? ""
        onEventSubject.send(.connected(["Sec-WebSocket-Protocol":p]))
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        var r = ""
        if let d = reason {
            r = String(data: d, encoding: .utf8) ?? ""
        }
        onEventSubject.send(.disconnected(r, UInt16(closeCode.rawValue)))
    }
}
