//
//  ChatFragment.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/27.
//

import Foundation
import SwiftyJSON
import CoreLocation
import CSAccountManager
import CSSpyExpert
import CSUtilities
import Combine

class ChatFragment: WidgetFragment {
    
    var onReceiveMessageSubject = PassthroughSubject<CSChatMessage, Never>()
    var onWillDisplaySubject = PassthroughSubject<Void, Never>()

    override func receive(message: JSON) {
        
        guard let name = message["name"].string,
              let uid = message["uid"].uInt,
              let content = message["content"].string else {
            print("message is error = \(message)")
            return
        }
        let userType = uid == AccountManager.shared.id ? userType.me : userType.other
        let time = message["time"].doubleValue
        let chatMessage = CSChatMessage(userName: name, userId: String(uid), avatarUrl: message["avatar"].stringValue, messageId: message["messageId"].stringValue, message: content, currentUserType: userType, createTime: String(time))
        onReceiveMessageSubject.send(chatMessage)
    }
    
    func sendMessage( text: String) {
        let mine = assembly.usersManager().mine
        
        let message: JSON = [
            "content": text,
            "uid": AccountManager.shared.id,
            "time": Date().timeIntervalSince1970,
            "avatar": mine.info.avatar ?? "",
            "name": mine.info.name,
            "messageId": UUID().uuidString
        ]
        sendData(value: message)
        receive(message: message)
    }
    
    override func willDisplay() {
        onWillDisplaySubject.send(())
    }
    
    override var height: CGFloat {
        
        return 442
    }
    
    
}
