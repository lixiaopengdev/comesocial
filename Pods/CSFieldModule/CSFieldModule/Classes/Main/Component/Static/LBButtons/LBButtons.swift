//
//  LBButtons.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/1/17.
//

import UIKit
import CSUtilities
import SnapKit
import SwiftyJSON

class LBButtons: FieldBaseView {
    
    enum ActionType: Int {
        case message = 1
        case video
        case mic
        case micOff
        
        private var image: UIImage? {
            switch self {
            case .message:
                return UIImage.bundleImage(named: "field_message")
            case . video:
                return UIImage.bundleImage(named: "field_video")
            case .mic:
                return UIImage.bundleImage(named: "field_mic")
            case .micOff:
                return UIImage.bundleImage(named: "field_mic_off")
            }
        }
        
        func buildButton() -> UIButton {
            let btn = UIButton(type: .custom)
            btn.setImage(image, for: .normal)
            btn.tag = rawValue
            return btn
        }
    }
    
    let stackView: UIStackView = {
        let stackV = UIStackView()
        stackV.axis = .horizontal
        stackV.alignment = .center
        stackV.spacing = 12
        return  stackV
    }()
    
    var actions: [ActionType] = [.message, .video]

    override func initialize() {
        backgroundColor = UIColor(hex: 0x1b1b1b)
        layerCornerRadius = 17
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12))
        }
        for action in actions {
            addAction(action)
        }
    }

    
    func addAction(_ action: ActionType) {
        let button = action.buildButton()
        button.addTarget(self, action: #selector(clickActionBtn(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    
    @objc private func clickActionBtn(_ btn: UIButton) {
        let action = ActionType(rawValue: btn.tag)
        
        switch action {
        case .message:
            break
        case .video:
            let jsonO = [
                "action": PA.propInit.rawValue,
                "version": 1,
                "prop": nil
            ] as? [String: Any?]
            let json = JSON(jsonO)
            guard let message = json.rawString(options: []) else {
                assertionFailure("json error")
                return
            }
            assembly.roomMessageChannel().askMessage(event: .propUpdate, message: message)
        default:
            break
            
        }
        

        
//        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
//            self.stackView.arrangedSubviews[btn.tag - 1].isHidden = true
//        }
        

        
    }
    //    override var intrinsicContentSize: CGSize {
    //        let w = 12 * 2 + actions.count * 24 + (actions.count - 1) * 12
    //        return CGSize(width: w, height: 34)
    //    }
    deinit {
        print("LBButtons deinit")
    }
    
}
