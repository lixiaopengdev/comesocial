//
//  ChangePhoneNumberViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/9.
//

import Foundation
import CSBaseView
import CSUtilities
import Combine

class ChangePhoneNumberViewController: BaseViewController {
    
    private var cancellableSet: Set<AnyCancellable> = []

    let editField: TextField = {
        let field = TextField()
        field.textColor = .cs_pureWhite
//        field.placeholder = "Phone Number"
        field.attributedPlaceholder = NSAttributedString(string: "Phone Number").foregroundColor(.cs_lightGrey).font(.regularHeadline)
        field.maxCharactersLimit = 100
        field.font = .regularHeadline
        field.keyboardType = .numberPad
        field.contentEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 10)
        return field
    }()
    

    lazy var nextBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "gradient_button_circle"), for: .normal)
        button.setImage(UIImage.bundleImage(named: "gradient_button_circle_disable"), for: .disabled)
        button.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorA_40
        view.layerCornerRadius = 12
        return view
    }()
    
    let leftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .cs_cardColorB_40
        btn.cornerRadius(corners: [.topLeft, .bottomLeft], radius: 12)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Phone Number"
        
        leftBtn.setTitle("🇺🇸 +1", for: .normal)

        view.addSubview(containerView)
        containerView.addSubview(leftBtn)
        containerView.addSubview(editField)

        view.addSubview(nextBtn)

       
        containerView.snp.makeConstraints { make in
            make.left.equalTo(52)
            make.right.equalTo(-52)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(135)
            make.height.equalTo(48)
        }
        leftBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(84)
        }
        editField.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(leftBtn.snp.right)
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


    @objc func nextClick() {
        navigationController?.pushViewController(ChangeNumberCodeViewController(), animated: true)
    }
    
    
    override var backgroundType: BackgroundType {
        return .dark
    }
}
