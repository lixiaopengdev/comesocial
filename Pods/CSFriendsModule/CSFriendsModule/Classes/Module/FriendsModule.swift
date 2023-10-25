//
//  FriendsModule.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator


public class FriendsModule: MediatorModuleProtocol {
    
    public static let shared = FriendsModule()
    
    public func bootstrap() {
        
        Mediator.register(FriendsService.ViewControllerService.self) { _ in
            return FriendViewControllerServiceImp()
        }
    }
}
