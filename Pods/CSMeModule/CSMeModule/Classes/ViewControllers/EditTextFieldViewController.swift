//
//  EditTextFieldViewController.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/9.
//

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation
import Combine
import CSNetwork

class EditTextFieldViewController: BaseViewController {
    
    private var cancellableSet: Set<AnyCancellable> = []
    var keyboardCancellable: AnyCancellable?

    private var userNameCancellable: AnyCancellable?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_cardColorA_40
        view.layerCornerRadius = 14
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_lightGrey
        label.font = .regularSubheadline
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_lightGrey
        label.font = .regularSubheadline
        label.numberOfLines = 0
        return label
    }()
    
    let editField: TextField = {
        let field = TextField()
        field.textColor = .cs_pureWhite
        //        field.placeholder = "..."
        field.maxCharactersLimit = 20
        field.font = .boldBody
        field.rightViewMode = .whileEditing
        return field
    }()
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .boldBody
        button.setTitleColor(.cs_pureWhite, for: .normal)
        button.setBackgroundImage(UIImage.bundleImage(named: "gradient_button_rect"), for: .normal)
        button.setBackgroundImage(UIImage.bundleImage(named: "gradient_button_rect_disable"), for: .disabled)
        
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return button
    }()
    
    //    let titleContent: String
    //    let editContent: String?
    
    let type: MyProfileEditType
    
    init(type: MyProfileEditType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit Profile"
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(editField)
        view.addSubview(detailLabel)
        view.addSubview(saveBtn)
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(74)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(12)
            make.right.equalTo(-16)
        }
        editField.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.equalTo(-16)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(containerView.snp.bottom).offset(12)
            make.right.equalTo(-30)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 48))
            make.bottom.equalTo(-KeyboardAnimator.keyboardEstimatedHeight - 24)
        }
        
        titleLabel.text = type.title
        navigationItem.title = type.title
        editField.text = type.content
        
        editField.textDidChangeCallback = {[weak self] tf in
            self?.tryCheckValue()
        }
        
   
        editField.becomeFirstResponder()
        saveBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardCancellable = KeyboardAnimator
            .publisher()
            .sink { [weak self] info in
                guard let self = self else { return }
                if info.isShow {
                    self.saveBtn.snp.remakeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.size.equalTo(CGSize(width: 200, height: 48))
                        make.bottom.equalTo(-info.keyboardFrame.height - 24)
                    }
                } else {
                    self.saveBtn.snp.remakeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.size.equalTo(CGSize(width: 200, height: 48))
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
                    }
                }
                UIView.animate(withDuration: 0, delay: 0, options: info.animationOptions) {
                    self.view.layoutIfNeeded()
                }
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardCancellable?.cancel()
    }
    
    @objc func saveClick() {
        guard let newText = editField.text,
              !newText.isEmpty else {
            showErrorTips("\(type.title) is empty")
            return
        }
        
        guard newText != type.content else {
            showErrorTips("The \(type.title.lowercased()) is the same as before")
            return
        }
        MyProfileManager.share.editProfile(type: type.mapValue(newText), success: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }, failure: { [weak self] error in
            self?.showErrorTips(error.localizedDescription)
        })
    }
    
    private func showErrorTips(_ tips: String) {
        self.detailLabel.attributedText = NSAttributedString(string: tips).foregroundColor(.cs_systemRed)
        saveBtn.isEnabled = false
    }
    
    private func tryCheckValue() {
        showErrorTips("")
        guard let text = editField.text,
              !text.isEmpty else {
            self.saveBtn.isEnabled = false
            return
        }
        self.saveBtn.isEnabled = true
        switch type {
        case .userName(_):
            userNameCancellable?.cancel()
            userNameCancellable = Network.requestPublisher(UserService.dupName(name: text)).mapVoid().sinkFailure { [weak self] error in
                self?.showErrorTips(error.errorTips ?? "")
            }
        default:
            break
            
        }
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
}

