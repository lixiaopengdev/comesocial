//
//  UserLabelFragment.swift
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

class UserLabelFragment: WidgetFragment {
    
    class LabelUser {
        let id: UInt
        let name: String
        @Published var label: String = ""
        
        init(id: UInt, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    @Published var labelUsers: [LabelUser] = []
    var labelInfo: JSON = JSON()
    var font: UIFont = UIFont.name(.avenirNextRegular, size: 17)

    override func mapping(map: ObjectMapper.Map) {
        font     <- (map["font"], FontTransform())
    }
    
    override func initialize() {
        assembly.usersManager().$users.sink { [weak self] users in

            self?.labelUsers = users.map({ user in
                return LabelUser(id: user.id, name: user.displayName)
            })

            self?.invalidateHeight()
            self?.updateMessage()
        }.store(in: &cancellableSet)
        
        assembly.healthReader().getStepCount { [weak self] arg in
            if let step = try? arg.get() {
                self?.syncText(String(Int(step)))
            } else {
                self?.syncText("secrecy")
            }
        }
    }
    
    override func update(full: JSON, change: JSON) {
        labelInfo = full
        updateMessage()
    }
    
    func syncText(_ text: String) {
        let mineId = AccountManager.shared.id
        if let mineMessage = labelUsers.first(where: { $0.id == mineId})?.label,
           mineMessage == text {
            return
        }
        syncData(value: [String(mineId): text])
    }
    
    func updateMessage() {
        for user in labelUsers {
            user.label = labelInfo[String(user.id)].string ?? "secrecy"
        }
    }
    
    override var height: CGFloat {

        return CGFloat(labelUsers.count * 45)
    }
    
    
}
