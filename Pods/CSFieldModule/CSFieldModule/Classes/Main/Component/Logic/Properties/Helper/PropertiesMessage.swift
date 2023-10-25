//
//  PropertiesBuilder+Message.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/28.
//

import Foundation
import SwiftyJSON
import CSAccountManager

struct PropertiesMessage {
    
    let assembly: FieldAssembly
    
    init(assembly: FieldAssembly) {
        self.assembly = assembly
    }
    
    func createWidget(instanceId: String, data: [AnyHashable : Any]) {
        
        let currentVersion = assembly.resolve(type: Properties.self).currentVersion
//        let id = instanceId + "." + String(currentVersion)
        
        let message = PropertiesBuilder
            .action(.createWidget)
            .widget(instanceId)
            .addId()
            .addData(data)
            .addOrder(Int(currentVersion))
            .string
        print(message)
        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func updateWidget(instanceId: String, data: JSON) {
        
        let message = PropertiesBuilder
            .action(.updateWidget)
            .widget(instanceId)
            .addValue(data)
            .string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func useJs(card: CardModel) {
        
        let message = PropertiesBuilder.action(.useJS).js(card).string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func ChangeMyVideo(open: Bool) {
        
        let fullProp = assembly.resolve(type: Properties.self).fullProp

        let oriOpen = fullProp[PK.user]["\(AccountManager.shared.id)"]["video"].boolValue
        if open == oriOpen { return }
        
        let message = PropertiesBuilder
            .action(.vedioStatus)
            .user(AccountManager.shared.id)
            .openVideo(open)
            .string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func ChangeMyPhoto(photo: String) {
        
        let message = PropertiesBuilder
            .action(.photo)
            .user(AccountManager.shared.id)
            .changePhoto(photo)
            .string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func UpdateMe(widget: JSON) {
        
        let message = PropertiesBuilder
            .action(.updateMeWidget)
            .user(AccountManager.shared.id)
            .updateWidget(widget)
            .string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func removeMine() {
        
        let message = PropertiesBuilder
            .action(.removeMine)
            .user(AccountManager.shared.id)
            .setNull()
            .string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
    func updateRoomInfo(data: JSON) {
        
        let message = PropertiesBuilder
            .action(.updateRoomInfo)
            .info(data)
            .string
        print(message)

        assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
    }
    
}
