//
//  CSRobotView.swift
//  CSRobotView
//
//  Created by fuhao on 2023/5/29.
//

import UIKit
import YYImage
import SnapKit

public enum RobotState {
    case state_disconnect
    case state_force_hard
    case state_look_down
    case state_pull_down
    case state_try_connect
    case state_excited_peek
    case state_jump
    case state_normal
    case state_receive_message
    
    
    var assetName:String {
        switch self {


        case .state_disconnect:
            return "state_disconnect"
        case .state_force_hard:
            return "state_force_hard"
        case .state_look_down:
            return "state_look_down"
        case .state_pull_down:
            return "state_pull_down"
        case .state_try_connect:
            return "state_try_connect"
        case .state_excited_peek:
            return "state_excited_peek"
        case .state_jump:
            return "state_jump"
        case .state_normal:
            return "state_normal"
        case .state_receive_message:
            return "state_receive_message"
        }
    }
}

public typealias OnRobotTap = (_ currentState: RobotState)->Void

public class CSRobotView: UIView {
    let imageView = YYAnimatedImageView()
    let speechContainer = UIView()
    let speechLabel = UILabel()
    
    var currentState: RobotState = .state_normal
    var currentScene: RobotMode = .InitMode
    
    var mOnRobotTap: OnRobotTap?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(imageView)
        self.addSubview(speechContainer)
        speechContainer.addSubview(speechLabel)
        speechContainer.layer.backgroundColor = UIColor(red: 0.358, green: 0.342, blue: 0.567, alpha: 0.4).cgColor
        speechContainer.layer.cornerRadius = 16

        
        speechLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        speechLabel.font = UIFont.systemFont(ofSize: 15)
        speechLabel.numberOfLines = 0
        speechLabel.lineBreakMode = .byWordWrapping
        saySomething()

        
        imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(100)
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(robotClick)))
        
        
        
        speechContainer.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(imageView)
            make.bottom.lessThanOrEqualToSuperview()
            
//            make.bottom.equalTo(imageView).offset(-50 + 20)
            make.height.greaterThanOrEqualTo(31)
        }
        
        speechLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }

        setState(state: currentState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func say(content: String?) {
        guard let content = content else {
            speechLabel.text = nil
            speechContainer.isHidden = true
            return
        }
        speechContainer.needsUpdateConstraints()
        speechContainer.layoutIfNeeded()
        speechContainer.isHidden = false
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        // Line height: 23 pt
        // (identical to box height)
        speechLabel.attributedText = NSMutableAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    public func saySomething() {
        let saying = currentScene.randomSaying
        say(content: saying)
    }
    
    public func setState(state: RobotState) {
        guard let url = Bundle(for: CSRobotView.self).url(forResource: "CSRobotView", withExtension: "bundle"),
              let localBundle = Bundle(url: url),
              let gifURL = localBundle.url(forResource: state.assetName, withExtension: "png"),
              let data = try? Data(contentsOf: gifURL),
              let image = YYImage(data: data) else {
            return
        }
        
        imageView.image = image
        currentState = state
    }
    
    public func setScene(state: RobotMode) {
        currentScene = state
        saySomething()
    }
    
    public func captureRobotTap( onRobotTap: OnRobotTap?) {
        mOnRobotTap = onRobotTap
        if onRobotTap == nil {
            imageView.isUserInteractionEnabled = false
        }else {
            imageView.isUserInteractionEnabled = true
        }
        
    }
    
    
    @objc
    fileprivate func robotClick() {
        guard let onRobotTap = mOnRobotTap else {
            return
        }
        onRobotTap(currentState)
    }
}
