//
//  DeleteAccountViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/6/21.
//

import Foundation
import CSBaseView
import CSCommon
import CSUtilities
import CSNetwork
import CSAccountManager
import Combine

class DeleteAccountViewController: BaseViewController {
    
    private var cancellableSet = Set<AnyCancellable>()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        label.text = "Are you sure you want to delete your account?"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .regularSubheadline
        label.text = "This action can't be recovered"
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .boldBody
        button.layerCornerRadius = 12
        button.setTitleColor(.cs_pureWhite, for: .normal)
        button.setBackgroundColor(color: .cs_primaryPink, forState: .normal)
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
//        view.addSubview(emailLabel)
        view.addSubview(deleteBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(66)
            make.right.equalTo(-66)

        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(42)
        }
        
//        emailLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(subtitleLabel.snp.bottom).offset(50)
//        }
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-180)
            make.size.equalTo(CGSize(width: 200, height: 48))
        }
    }
    
    @objc func deleteAccount() {

        Network.requestPublisher(UserService.delete).mapVoid().sink { _ in
            AccountManager.shared.logout()
        } failure: { error in
            HUD.showError(error)
        }.store(in: &cancellableSet)

    }
}
