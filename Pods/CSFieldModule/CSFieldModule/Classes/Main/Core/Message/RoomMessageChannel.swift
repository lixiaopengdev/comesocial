//
//  FieldRoom.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/13.
//

import CSWebsocket
import JSEngineKit
import CSLogger
import CSUtilities
import Combine

class RoomMessageChannel: FieldComponent {
    
    let assembly: FieldAssembly
    var room: RoomClient?
    
    private var cancellableSet: Set<AnyCancellable> = []

    @Published var isJoined: Bool = false
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
    }

    var name: String {
        return assembly.id.string
    }
    
    func bootstrap() {
        initMessage()
    }
//
    func initialize() {
        
//        assembly
//            .cardManager()
//            .onCardComplete
//            .sink {[weak self] complete in
//                switch complete {
//                case .finished:
//                    self?.initMessage()
//                case .failure(_):
//                    HUD.showError("field init fail")
//                }
//            } receiveValue: { result in
//                print(result)
//            }.store(in: &cancellableSet)
    }
    
    func initMessage() {
        room = FieldRoot.shared.fieldNamespaceClient.registerRoom(assembly.id.string)

        room?
            .$isConnected
            .weakAssign(to: \.isJoined, on: self)
            .store(in: &cancellableSet)
        
        room?
            .onReceiveError
            .sink { error in
                HUD.showError(error.localizedDescription)
            }
            .store(in: &cancellableSet)
        
        room?
            .onReceiveMessage.sink { [weak self] msg in
                self?.receiveMessage(msg)
            }
            .store(in: &cancellableSet)
    }
    
    func sendMessage(event: FieldEvent, message: String) {
        room?.emit(event: event.rawValue, body: message)
    }
    
    func askMessage(event: FieldEvent, message: String) {
        room?.ask(event: event.rawValue, body: message)
    }
    
    func sendMessage(event: FieldEvent, data: Any) {
        
        if let message = MessageUtility.toJson(data) {
            sendMessage(event: event, message: message)
        }
    }

    private func receiveMessage(_ msg: Message) {
        let event = FieldEvent(msg.event)
        switch event {
        case .renderWidget:
            onRenderWidget(body: msg.body)
        case .roomInfo:
            onRoomInfo(body: msg.body)
        case .userJoin:
            onUserJoin(body: msg.body)
        case .userLeft:
            onLeft(body: msg.body)
        case .brodcastAction:
            onBrodcastAction(body: msg.body)
        case .propUpdate:
            onJsonPatch(body: msg.body)
        case .unknow:
            logger.error("unknow event: \(msg.event)")
        case .widgetMessage:
            onWidgetMessage(body: msg.body)
        }
    }
    
    func willDestory() {
        
    }
    
    func didDestory() {
        room?.logoutRoom()
    }
    
    deinit {
        print("FieldRoom deinit")
    }
    
}


// MARK: --- logic
extension RoomMessageChannel {
    
    func onRenderWidget(body: String) {
        guard let des = MessageUtility.JsonTo(body) as? [AnyHashable : Any],
        let id = des["instanceId"] as? String else{
            assertionFailure("deserialization error")
            return
        }
        JSEngineRegister.shared.nativeMethodImp.renderWidget(withJSRender: id, data: des)
    }
 
    
    func onBrodcastAction(body: String) {
        guard let des = MessageUtility.JsonTo(body) as? [AnyHashable : Any],
              let id = des["instanceId"] as? String,
              let content = des["content"] as? [String: Any] else {
            assertionFailure("deserialization error")
            return
        }
        
        guard let actionName = content["actionName"] as? String else {
            assertionFailure("deserialization error")
            return
        }
        var args: [Any]? = nil
        if let value = content["args"] {
            if let value = value as? [Any] {
                args = value
            } else {
                args = [value]
            }
        }
        YZJSEngineManager.shared().callJSMethod(actionName, instanceId: id, args: args)
    }

}

// MARK: --- user
extension RoomMessageChannel {
    
    func onRoomInfo(body: String) {
        assembly.usersManager().updateRoomInfo(body)
    }
    
    func onUserJoin(body: String) {
        assembly.usersManager().onUserJoined(body)
    }
    
    func onLeft(body: String) {
        assembly.usersManager().onLeft(body)
    }

}


// MARK: --- properties
extension RoomMessageChannel {
    func onJsonPatch(body: String) {
        assembly.properties().enqueue(merge: body)
    }
}

// MARK: --- widget
extension RoomMessageChannel {
    func onWidgetMessage(body: String) {
        assembly.widgetContainer().receiveWidgetMessage(body)
    }
}
