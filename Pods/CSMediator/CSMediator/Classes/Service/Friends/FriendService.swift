//
//  FriendService.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/20.
//

public protocol FriendViewControllerService {
    
    func homeViewController() -> UIViewController
    func hiddenUserViewController() -> UIViewController
    func inviteToFieldViewController() -> UIViewController
    func connectRequestViewController() -> UIViewController

}

public enum FriendsService {
    
    public typealias ViewControllerService = FriendViewControllerService
    
}


