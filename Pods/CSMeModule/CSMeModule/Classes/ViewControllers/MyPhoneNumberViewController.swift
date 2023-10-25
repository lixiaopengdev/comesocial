//
//  MyPhoneNumberViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/9.
//

import Foundation
import CSBaseView

class MyPhoneNumberViewController: BaseViewController {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularHeadline
        label.text = "Linked Number"
        return label
    }()
    
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldLargeTitle
        return label
    }()

   
//    lazy var changeBtn: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setTitle("Change Number", for: .normal)
//        button.titleLabel?.font = .boldBody
//        button.setTitleColor(.cs_pureWhite, for: .normal)
//        button.setBackgroundImage(UIImage(color: .cs_cardColorA_20, size: CGSize(width: 1, height: 1)), for: .normal)
//        button.layerCornerRadius = 10
//        button.addTarget(self, action: #selector(changeClick), for: .touchUpInside)
//        return button
//    }()
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Phone Number"
        
        view.addSubview(titleLabel)
        view.addSubview(numLabel)
//        view.addSubview(changeBtn)

        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(170)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
//        changeBtn.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.size.equalTo(CGSize(width: 250, height: 54))
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }

        numLabel.text = MyProfileManager.share.user?.mobileDisplay
    }


    @objc func changeClick() {
        navigationController?.pushViewController(ChangePhoneNumberViewController(), animated: true)
    }
    
    
    override var backgroundType: BackgroundType {
        return .dark
    }
}
