//
//  AccountManager.swift
//  CSAccountManager
//
//  Created by 于冬冬 on 2023/1/9.
//

import Foundation
import CSUtilities
import Combine
import CSNetwork

public final class AccountManager {

    private var cancellableSet = Set<AnyCancellable>()
    static private let userKey = "userkey.name"
    
    public static let shared = AccountManager()
    
    private var accountInfo: AccountInfo? {
        didSet {
            isLogin = accountInfo != nil
        }
    }
    
//    public var name: String {
//        return accountInfo?.name ?? ""
//    }
    
    public var id: UInt {
        return accountInfo?.id ?? 0
    }
    
//    public var fieldId: UInt {
//        return accountInfo?.field ?? 0
//    }
//
//    public var avatar: String {
//        return accountInfo?.avatar ?? ""
//    }
    
    @Published public private(set) var isLogin: Bool = false
//    public let accountInfoChangedSubject = CurrentValueSubject<AccountInfo?, Never>(nil)
    
    init() {
        
        if let account = UserDefaults.standard.object(AccountInfo.self, with: AccountManager.userKey) {
            accountInfo = account
            isLogin = true
//            sendInfoChanged()
        }
        
        Network.onNetErrorSubject.sink { [weak self] error in
            self?.handleNetworkError(error)
        }.store(in: &cancellableSet)
        
    }
    
//    func sendInfoChanged() {
//        accountInfoChangedSubject.send(accountInfo)
//    }
    
    func handleNetworkError(_ error: NetworkError) {
        switch error {
        case let .server(errorType, _):
            switch errorType {
            case .unLogin:
                logout()
            default:
                break
            }
        default:
            break
        }
    }
    
    // 临时方案
//    public func updateInfo(name: String, avatar: String, field: UInt) {
//        if self.accountInfo?.name != name || self.accountInfo?.avatar != avatar || self.accountInfo?.field != field{
//            self.accountInfo?.name = name
//            self.accountInfo?.avatar = avatar
//            self.accountInfo?.field = field
//            sendInfoChanged()
//            UserDefaults.standard.set(object: accountInfo, forKey: AccountManager.userKey)
//        }
//    }
    
    public func initUid(_ uid: UInt) {
        
        let accountInfo = AccountInfo(uid: uid)
        self.accountInfo = accountInfo
//        sendInfoChanged()
        UserDefaults.standard.set(object: accountInfo, forKey: AccountManager.userKey)
    }
    
//    public func initAccount(_ account: AccountProtocol) {
//
//        let accountInfo = AccountInfo(account: account)
//        self.accountInfo = accountInfo
//        sendInfoChanged()
//        UserDefaults.standard.set(object: accountInfo, forKey: AccountManager.userKey)
//    }
    
    public  func logout() {
        accountInfo = nil
//        sendInfoChanged()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        UserDefaults.standard.removeObject(forKey: AccountManager.userKey)
        UserDefaults.standard.synchronize()
    }
}
