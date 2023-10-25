

import UIKit
import CSUtilities

public var screenW = UIScreen.main.bounds.size.width

public var screenH = UIScreen.main.bounds.size.height

public let EMOJI_KEYBOARD_HEIGHT = (4 * screenW * 0.0875 + (3 + 1) * ((screenW - 7 * screenW * 0.0875 ) / 8) + 20)

public let BLUE_Color            = UIColor(red: 22.0 / 255.0, green: 128.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)

public let BACKGROUND_Color      = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)

public let navColor              = UIColor.init(red: 57 / 255, green: 56 / 255, blue: 54 / 255, alpha: 1.0)


///toolbar
public let toobarH          = 64.0

public var TextViewW        = screenW - 28.0

public let TextViewH        = 38.0

public var nameW      = screenW - 78.0

public let nameH      = 16.0

public var emotionBtnX      = screenW - (screenW * 40 / 320)

public let toolBarFrameDown = CGRect(x:0, y:screenH - toobarH, width:screenW, height:toobarH)

public let toolBarFrameUPBaseEmotion = CGRect(x:0, y:screenH - toobarH - EMOJI_KEYBOARD_HEIGHT, width:screenW, height:toobarH)

public let Vgap = screenW * 5 / 320

public let Lgap = screenW * 10 / 320

///emotionView
public let emotionUpFrame   = CGRect.init(x: 0, y: screenH - (EMOJI_KEYBOARD_HEIGHT), width: screenW, height: EMOJI_KEYBOARD_HEIGHT)

public let emotionDownFrame = CGRect.init(x: 0, y: screenH, width: screenW, height: EMOJI_KEYBOARD_HEIGHT)

public let emotionTipTime   = 0.25

public class CSChatCellStore: NSObject {
    
    var blurView = TSBlurEffectView()
    
    var iconFrame         = CGRect()
    
    var nameFrame         = CGRect()
    
    var textFrame         = CGRect()
    
    var topLabelFrame = CGRect()
    
    var progressFrame = CGRect()
    
    var imageViewFrame    = CGRect()
    
    var cellHeight        = CGFloat()
    
    var topLtext =  String()
    
    private let iconW:CGFloat    = 32.0
    
    private let iconH:CGFloat    = 32.0
    
    private let padding:CGFloat  = 10.0
    
    private let iconLPadding: CGFloat = 12.0
    
    private let iconRPadding: CGFloat = 10.0
    
    private let aPadding:CGFloat = 78.0

    var message:CSChatMessage {
    
        didSet {computeFrames()}
    }
    
    override init() {
        self.message = CSChatMessage()
        super.init()
    }
    //计算frame
    func computeFrames() {
        
        let uType:Bool = message.currentUserType == userType.other
                
        let timestamp = Double(message.createTime) ?? Date().timeIntervalSince1970
        let timeInterval = Date().timeIntervalSince1970 - timestamp
        let minutes = Int(timeInterval / 60)
        var hasTime:Bool = false
        if minutes > 1 {
            hasTime = true
            topLtext = String(format: "%d mins ago", minutes)
        }
        
        topLabelFrame = hasTime ? CGRectMake(0, 0, screenW, 16) : CGRectZero
        
        let topPadding = hasTime ? topLabelFrame.maxY + 6 : 0
        
        //头像
        let iconFrameX:CGFloat = uType ? iconLPadding : screenW - iconLPadding - iconW
        let iconFrameY:CGFloat = iconRPadding + topPadding
        let iconFrameW:CGFloat = iconW
        let iconFrameH:CGFloat = iconH
        iconFrame = CGRect.init(x: iconFrameX, y: iconFrameY, width: iconFrameW, height: iconFrameH)
        
        //名字
        nameFrame = uType ? CGRect.init(x: iconFrame.maxX + iconRPadding, y: iconFrameY - 4, width: nameW, height: nameH) : CGRect.init(x: screenW - padding * 2 - iconFrameW - nameW, y: iconFrameY, width: 0, height: 0)
        
        if message.msgType == .textMessage {
          
            //message
            let str:String = (message.message)
            let textAtt = CSChageEmotionStrTool.changeStr(string: str, font: .regularBody, textColor: .cs_softWhite)
            message.attMessage = textAtt
            let maxsize:CGSize = CGSize.init(width: Int(screenW - aPadding - 24), height: 1000)
            let textSize:CGSize = textAtt.boundingRect(with: maxsize, options: .usesLineFragmentOrigin, context: nil).size
            let emojiSize:CGSize = CGSize.init(width: textSize.width + padding * 2, height: textSize.height + padding * 2)
            textFrame = uType ? CGRect.init(x: 54, y: iconFrameY + iconFrameH * 0.5, width: emojiSize.width, height: emojiSize.height) : CGRect.init(x: screenW - 54 - emojiSize.width, y: iconFrameY - 5, width: emojiSize.width, height: emojiSize.height)
            
            progressFrame = CGRectMake(0, textFrame.maxY + 4, textFrame.width - 14 , 2)
            
            cellHeight = progressFrame.maxY + 12;
            
            
        }else if message.msgType == .gifMessage {
        
            imageViewFrame = uType ? CGRect.init(x: padding * 2 + iconFrameW, y: iconFrameY + iconFrameH * 0.5, width: 100, height: 100) : CGRect.init(x: screenW - padding * 2 - iconFrameW - 100, y: iconFrameY + iconFrameH * 0.5, width: 100, height: 100);
            
            cellHeight = imageViewFrame.maxY + padding;
            
        }else {
    
            
        }
    }
    
}
