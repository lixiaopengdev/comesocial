//
//  LiveService.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/20.
//

public protocol LiveViewControllerService {
    
    func homeViewController() -> UIViewController
    func shareTimeDewViewController(titleText: String, contentText: String, photoImageURL: String?, contentImageURL: String?) -> UIViewController
    func moreFunction(requestSessionId: String, timeDewId: UInt, timeDewType: String, isSaveTimeDew: String?) -> UIViewController
}

public protocol LiveTimeDewService {
    func cancelSaveTimeDew(id: Int, type: String)
    func editlSaveTimeDew(id: Int, type: String, editHandle: Int)

    func doReactionTimeDew(id: Int, type: String, editHandle: Int)
    func jumpFieldTimeDew(fieldId: UInt)
    func inviteJoinField(inviteUserId: UInt)

}

public enum LiveService {
    
    public typealias ViewControllerService = LiveViewControllerService
    public typealias TimeDewService = LiveTimeDewService

}
