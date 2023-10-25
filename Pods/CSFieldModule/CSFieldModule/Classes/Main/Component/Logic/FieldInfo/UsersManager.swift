//
//  FieldInfoHelper.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/14.
//

import Foundation
import CSAccountManager
import Combine


class UsersManager: FieldComponent {
    
    let assembly: FieldAssembly
    var cancellableSet: Set<AnyCancellable> = []

    private let id: UInt
//    private let name: String
    @Published private(set) var users: [FieldUserKit] = []
    let onUserChanged = PassthroughSubject<(users: [FieldUserKit], joind: Bool), Never>()
    
    var mine: FieldUserKit {
        return getUser(AccountManager.shared.id)!
    }
    
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
        id = assembly.id
//        name = assembly.field.name
        let mine = FieldUserModel.createMine()
        let mineKit = FieldUserKit(userInfo: mine, assembly: assembly)
        users.append(mineKit)
        notifyUserChanged([mineKit], true)
    }
    
    func initialize() {
//        assembly
//            .roomMessageChannel()
//            .$isJoined
//            .sink { [weak self] joined in
//                if joined {
//
//                }
//            }
//            .store(in: &cancellableSet)
    }
    
    private func addUser(_ user: FieldUserKit) {
        if let oldUser = getUser(user.id) {
//            assertionFailure("user already exist")
            deleteUser(user.id)
        }
        users.append(user)
//        print("1===== \(user.id)")
    }
    
    func getUser(_ id: UInt) -> FieldUserKit? {
        return users.first(where: { $0.id == id })
    }
    
    private func deleteUser(_ id: UInt) {
//        print("2===== \(id)")

        users.removeAll(where: { $0.id == id })
    }
    
    
    
    
    func updateRoomInfo(_ info: String) {
        // 删除之前的user， 如果存在的话（断线重连之类的触发）
        let otherUsers = users.filter({ !$0.isLocal })
        if !otherUsers.isEmpty {
            users.removeAll(where: { !$0.isLocal })
            notifyUserChanged(otherUsers, false)
        }

//        print("===== \(info)")
        
        var newUsers = [FieldUserKit]()
        if let roomInfo = RoomInfoModel(JSONString: info) {
            for user in roomInfo.users {
                let userKit = FieldUserKit(userInfo: user, assembly: assembly)
                addUser(userKit)
                newUsers.append(userKit)
            }
        }
//        if newUsers.count == 0 {
//            print("===== \(newUsers.count)")
//        }
//        print("===== \(newUsers.count)")

        notifyUserChanged(newUsers, true)
        
    }
    
    
    func onUserJoined(_ userString: String) {
        guard let user = FieldUserModel(JSONString: userString) else {
            return
        }
        if let userKit = getUser(user.id) { // 已存在
            userKit.updateInfo(info: user)
        } else {
            let userKit = FieldUserKit(userInfo: user, assembly: assembly)
            addUser(userKit)
            notifyUserChanged([userKit], true)
        }
    }
    
    func onLeft(_ jsonString: String) {
        if let leftUser = MessageUtility.JsonTo(jsonString) as? [String: Any],
           let leftId = leftUser["user_id"] as? String,
           let leftId = UInt(leftId) {
            if let userKit = getUser(leftId) {
                deleteUser(leftId)
                notifyUserChanged([userKit], false)
            }
        }
    }

    func notifyUserChanged(_ changeUsers: [FieldUserKit], _ joined: Bool) {
        onUserChanged.send((changeUsers, joined))
    }
    
    
}
