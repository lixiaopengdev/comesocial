

import UIKit

enum userType {
    
    case me
    
    case other
}

enum messageType {
    
    case textMessage
    
    case imageMessage
    
    case videoMessage
    
    case locationMessage
    
    case gifMessage
}


class CSChatMessage: NSObject {
    
    var userName:String = String() // require
    
    var userId:String = String()  // require
    
    var avatarUrl:String = String() // Require

    var messageId:String = String() // Require

    var message:String  = String()  // Require
    
    var gifName:String  = String()  // message 二选一

    var attMessage      = NSMutableAttributedString()  // message 二选一
    
    var currentUserType = userType.me // Require
    
    var createTime = String() // Require
    
    var msgType = messageType.textMessage
    
    var invisible = false   // 已经显示结束
    
    var countingDown = false // 正在倒计时
    
    var progress:Float = 0.0
    
    var visibleTime = 3.0  // 单位秒
    override init() {
        super.init()
    }
    
    init(userName: String, userId: String, avatarUrl: String, messageId: String, message: String, currentUserType: userType = userType.me, createTime: String) {
        self.userName = userName
        self.userId = userId
        self.avatarUrl = avatarUrl
        self.messageId = messageId
        self.message = message
        self.currentUserType = currentUserType
        self.createTime = createTime
    }
}
