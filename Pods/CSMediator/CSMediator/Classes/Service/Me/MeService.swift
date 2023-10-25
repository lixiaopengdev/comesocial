//
//  MeService.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/20.
//

import Combine

public protocol MeViewControllerService {
    
    func homeViewController() -> UIViewController
    func profileViewController(uid: UInt) -> UIViewController
    func webViewController(url: URL?) -> UIViewController
}

public protocol MeProfileInfo: AnyObject {
    var name: String { get }
    var avatar: String? { get }
    var fieldId: UInt? { get }
}

public protocol MeProfileService {
    var profile: MeProfileInfo? { get }
    func profileUpdatePublisher() -> AnyPublisher<MeService.ProfileInfo?, Never>
}

public enum MeService {
    
    public typealias ViewControllerService = MeViewControllerService
    public typealias ProfileService = MeProfileService
    public typealias ProfileInfo = MeProfileInfo
    
}
