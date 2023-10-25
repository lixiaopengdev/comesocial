//
//  StationaryChatFragment.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/17.
//

import Foundation
import ObjectMapper
import CSUtilities
import UIKit
import Combine
import SwiftyJSON
import CSAccountManager

class StationaryChatFragment: WidgetFragment {
    
    class StationaryChatUser {
        let id: UInt
        let name: String
        @Published var message: String = ""
        
        init(id: UInt, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    @Published var chatUsers: [StationaryChatUser] = []
    var messageChat: JSON = JSON()

    
   override func initialize() {
        assembly.usersManager().$users.sink { [weak self] users in

            self?.chatUsers = users.map({ user in
                return StationaryChatUser(id: user.id, name: user.displayName)
            })

            self?.invalidateHeight()
            self?.updateMessage()
        }.store(in: &cancellableSet)
    }
    
    override func update(full: JSON, change: JSON) {
        messageChat = full
        updateMessage()
    }
    
    func syncText(_ text: String) {
        let mineId = AccountManager.shared.id
        if let mineMessage = chatUsers.first(where: { $0.id == mineId})?.message,
           mineMessage == text {
            return
        }
        syncData(value: [String(mineId): text])
    }
    
    func updateMessage() {
        for user in chatUsers {
            user.message = messageChat[String(user.id)].stringValue
        }
    }
    
    override var height: CGFloat {

        return CGFloat(chatUsers.count * 50)
    }
    
    
}
