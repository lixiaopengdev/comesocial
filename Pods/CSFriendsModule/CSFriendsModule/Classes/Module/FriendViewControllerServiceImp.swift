//
//  FriendServiceImp.swift
//  CSLiveModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator

struct FriendViewControllerServiceImp: FriendsService.ViewControllerService {
    func homeViewController() -> UIViewController {
        return FriendListViewController()
    }
    
    func hiddenUserViewController() -> UIViewController {
        return HiddenUserViewController()
    }
    
    func inviteToFieldViewController() -> UIViewController {
        return FriendInviteToFieldViewController()
    }
    
    func connectRequestViewController() -> UIViewController {
        return ConnectRequestController()
    }
    
    
}
