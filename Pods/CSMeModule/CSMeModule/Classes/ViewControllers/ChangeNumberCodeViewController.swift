//
//  ChangeNumberCodeViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/10.
//

import Foundation
import CSBaseView
import CSUtilities
import Combine
import AttributedString

class ChangeNumberCodeViewController: BaseViewController {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    let editField: TextField = {
        let field = TextField()
        field.textColor = .cs_pureWhite
        field.attributedPlaceholder = NSAttributedString(string: "111 111").foregroundColor(.cs_lightGrey).font(.regularHeadline)
        field.maxCharactersLimit = 100
        field.font = .regularHeadline
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        field.backgroundColor = .cs_cardColorB_40
        field.layerCornerRadius = 12
        field.isSecureTextEntry = true
        return field
    }()
    
    
    lazy var nextBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "gradient_button_circle"), for: .normal)
        button.setImage(UIImage.bundleImage(named: "gradient_button_circle_disable"), for: .disabled)
        button.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        return button
    }()
    
    let tipsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Phone Number"
        
        tipsLabel.attributed.text = "\("Don't receive it?", .font(.regularFootnote), .foreground(.cs_lightGrey)) \("Resend it.", .font(.regularFootnote), .foreground(.cs_decoLightPurple), .action(resend))"
        
        view.addSubview(editField)
        view.addSubview(tipsLabel)
        view.addSubview(nextBtn)
        
        editField.snp.makeConstraints { make in
            make.left.equalTo(52)
            make.right.equalTo(-52)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(135)
            make.height.equalTo(48)
        }
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(editField.snp.bottom).offset(16)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification).sink {[weak self] noti in
            guard let userInfo = noti.userInfo,
                  let keyboardFrameBegin = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
                  let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                  let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
                return
            }
            guard let self = self else { return }
            
            if keyboardFrameBegin.origin.y > keyboardFrameEnd.origin.y {
                self.nextBtn.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.size.equalTo(CGSize(width: 60, height: 60))
                    make.top.equalTo(keyboardFrameEnd.minY - 60 - 24)
                }
            } else if keyboardFrameBegin.origin.y < keyboardFrameEnd.origin.y {
                self.nextBtn.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.size.equalTo(CGSize(width: 60, height: 60))
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
                }
            }
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curveValue) ?? .linear)
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
            
        }.store(in: &cancellableSet)
        
        editField.becomeFirstResponder()
        
    }
    
    func resend() {
        print("resend")
    }
    
    @objc func nextClick() {
        
    }
    
    
    override var backgroundType: BackgroundType {
        return .dark
    }
}
