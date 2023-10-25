

import UIKit
import CSUtilities
import Kingfisher

class PaddedLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func addBlurEffectView() -> TSBlurEffectView {
       let blurView = TSBlurEffectView()
        blurView.intensity = 1
        blurView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.addSubview(blurView)
        return blurView
    }
    
    public func removeBlurEffectView() {
        for subView in self.subviews {
            if subView is TSBlurEffectView {
                subView .removeFromSuperview()
            }
        }
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            super.frame = newFrame
//            self.blurView.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

class CSChatMessageCell: UITableViewCell {
    
    private var iconImageView:UIImageView = UIImageView()
    
    private var nameLabel:UILabel      = UILabel()
    
    private var messageLabel:PaddedLabel   = PaddedLabel()
    
    private var gifimageView = UIImageView()

    private var topLabel:UILabel = UILabel()
    
    private var progressView:CSProgressView = CSProgressView()
        
    static func cellWithTableView(tableView:UITableView) ->CSChatMessageCell {
    
        let ID:String = "CSChatMessageCell"
        
        let cell:CSChatMessageCell = tableView.dequeueReusableCell(withIdentifier: ID) as! CSChatMessageCell
        
        return cell
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.chatCellStore = CSChatCellStore()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {

        self.backgroundColor = .clear
        
        //头像
        iconImageView.layer.cornerRadius  = 16.0
        iconImageView.layer.masksToBounds = true
        contentView.addSubview(iconImageView)
        
        //消息
        messageLabel.numberOfLines = 0
        messageLabel.layer.cornerRadius = 12.0
        messageLabel.layer.masksToBounds = true
        messageLabel.textAlignment = .center
        messageLabel.textInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 6)
        contentView.addSubview(messageLabel)
        
        contentView.addSubview(gifimageView)
        
        //名字
        nameLabel.font = .regularFootnote
        nameLabel.textColor = .cs_softWhite
        nameLabel.backgroundColor = .red
        contentView.addSubview(nameLabel)
        
        topLabel.font = .regularFootnote
        topLabel.textColor = .cs_lightGrey
        topLabel.textAlignment = .center
        contentView.addSubview(topLabel)
        
        progressView.backgroundColor = .cs_cardColorB_40
        progressView.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressView.progressColors = [.cs_decoMidPurple]
        progressView.layer.cornerRadius = 1
        progressView.progressCornerRadius = 1
//        progressView.progressUpdating = { [weak self] store, progress ,rect in
//            if progress >= 1.0 && store.message.messageId == self?.chatCellStore.message.messageId {
//                self?.messageLabel.blurView.alpha = 1
//                self?.chatCellStore.message.invisible = true
//            }
//        }
        contentView.addSubview(progressView)
        
    }
    
    var chatCellStore:CSChatCellStore {
        
        didSet {
            let uType:Bool = chatCellStore.message.currentUserType == userType.other
            
            //头像
            let url = URL(string: chatCellStore.message.avatarUrl)
            iconImageView.kf.setImage(with: url)
            
            iconImageView.frame = chatCellStore.iconFrame
            //名字
            nameLabel.text = chatCellStore.message.userName
            nameLabel.frame = chatCellStore.nameFrame
            nameLabel.textAlignment = uType ? NSTextAlignment.left : NSTextAlignment.right
            nameLabel.backgroundColor = .clear
            
            topLabel.text = chatCellStore.topLtext
            topLabel.frame = (chatCellStore.topLabelFrame)
            progressView.frame = (chatCellStore.progressFrame)
            progressView.store = chatCellStore
            progressView.setProgress(chatCellStore.message.progress, animated: false)
            if chatCellStore.message.currentUserType != .me {
                progressView.transform = CGAffineTransform.identity
            } else {
                progressView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            progressView.progressUpdating = { [weak self] store, progress ,rect in
                if progress >= 1.0 && store.message.messageId == self?.chatCellStore.message.messageId {
                    self?.chatCellStore.blurView =  self?.messageLabel.addBlurEffectView() ?? TSBlurEffectView()
                    self?.chatCellStore.message.invisible = true
                    self?.chatCellStore.message.progress = 1
                }
                self?.chatCellStore.message.progress = progress
                print("Current Progress: \(progress)")

            }
            
            if chatCellStore.message.msgType == .textMessage {
                
                //消息内容
                messageLabel.attributedText = chatCellStore.message.attMessage
                messageLabel.frame = (chatCellStore.textFrame)
                
                let messageColor:UIColor = uType ? UIColor.cs_3D3A66_40 : UIColor.cs_decoMidPurple
                messageLabel.backgroundColor = messageColor
//                messageLabel.titleEdgeInsets = uType ? UIEdgeInsetsMake(7, 13, 5, 5) : UIEdgeInsetsMake(5, 7, 5, 13)
                
                if chatCellStore.message.invisible {
                    messageLabel.removeBlurEffectView()
                    messageLabel.addSubview(chatCellStore.blurView)
                } else {
                    messageLabel.removeBlurEffectView()
                }
                
                gifimageView.frame = CGRect()
                progressView.animationDuration =  chatCellStore.message.visibleTime
//                progressView.centerX = messageLabel.centerX
                progressView.center = CGPoint(x: messageLabel.center.x, y: progressView.center.y)

            }else if chatCellStore.message.msgType == .gifMessage {
                
                let path:String = Bundle.main.path(forResource: chatCellStore.message.gifName, ofType: "gif")!
                
                let data = NSData.init(contentsOf: NSURL.init(fileURLWithPath: path) as URL)
                
//                let animationImage = UIImage.animationImageWithData(data: data);
             
//                gifimageView.image =  animationImage;
                
                gifimageView.frame = (chatCellStore.imageViewFrame)
                
                messageLabel.frame = CGRect()
            }
            
        }
    }
    
    public func starProgress() {
        if self.chatCellStore.message.invisible {
            return;
        }
        
        let delayTime = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.progressView.setProgress(1, animated: true)
        }
        self.chatCellStore.message.countingDown = true
    }
    
    public func pauseProgress() {
//        self.chatCellStore.message.progress = self.progressView.progress
    }
    
    public func resumeProgress() {
        self.progressView.setProgress(1, animated: true)
    }
    
    public func resetBlur() {
        
        if self.chatCellStore.message.invisible {
            
        } else {
            self.messageLabel.removeBlurEffectView()
            self.progressView.progress = 0
        }
    }
    
}
