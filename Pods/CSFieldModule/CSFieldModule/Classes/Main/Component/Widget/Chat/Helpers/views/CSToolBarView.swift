

import UIKit
import CSUtilities

class CSToolBarView: UIImageView {
    
    lazy var textView:TextView = {
    
        let textView = TextView.init(frame: CGRect.init(x: 14, y: 10, width: TextViewW, height: TextViewH))
        
        textView.backgroundColor = UIColor.cs_cardColorB_40
        
        textView.returnKeyType = UIReturnKeyType.send
        
        textView.layer.cornerRadius = 12
                
        textView.isScrollEnabled = true
        
        textView.font = .regularBody
        textView.placeholder = "Input Text"
        textView.placeholderColor = .cs_lightGrey
        textView.textColor = .white
        return textView;
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.frame = toolBarFrameDown
        
        self.initSomeThing()
        
        addSubview(self.textView)
        
    }
    
    func initSomeThing() {
    
        self.isUserInteractionEnabled = true
                
//        self.backgroundColor = .cs_3D3A66_20
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("初始化失败")
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            super.frame = newFrame
            self.textView.frame = CGRectMake(14, 10, newFrame.width - 28.0, newFrame.height - 26)
        }
    }
}
