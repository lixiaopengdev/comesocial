//
//  AccountInfo.swift
//  CSAccountManager
//
//  Created by 于冬冬 on 2023/1/9.
//

public protocol AccountProtocol {
//    var name: String { get }
    var id: UInt { get }
//    var avatar: String { get }
//    var field: UInt { get }

}

public struct AccountInfo: Codable {

    public let id: UInt

//    public var name: String
//    public var avatar: String
//    public var field: UInt

    init(uid: UInt) {
//        name = account.name
        id = uid
//        avatar = account.avatar
//        field = account.field
    }
}
