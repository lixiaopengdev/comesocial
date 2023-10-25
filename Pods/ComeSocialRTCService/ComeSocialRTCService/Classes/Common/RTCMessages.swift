////
////  RTCMessages.swift
////  ComeSocialRTCService
////
////  Created by fuhao on 2023/1/16.
////
//
//import Foundation
//
//public typealias SendToUser = (RTCError?) -> Void
//public typealias SendToRoomBoadcast = (RTCError?) -> Void
//
//class RTCMessagesSettings {
//    public static let shared = RTCMessagesSettings()
//    
//    var userToken: String?
//    
//    internal func setUserToken(userToken: String){
//        self.userToken = userToken
//    }
//    
//    internal func getUserToken() -> String {
//        guard let userToken = userToken else {
//            fatalError("userToken is nil")
//        }
//        return userToken
//    }
//}
//
//
//class RTCMessages {
//    
//        var sendToUser: SendToUser?
//        var sendToRoomBoadcast: SendToRoomBoadcast?
//    
//        //定时请求服务器数据的定时器
//        var countDownTimer: DispatchSourceTimer?
//    
//        var onUsersJoin: OnUsersJoin?
//        var onUsersLeave: OnUsersLeave?
//
//}
