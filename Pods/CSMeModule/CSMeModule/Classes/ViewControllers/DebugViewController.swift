//
//  DebugViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/5.
//

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation

class DebugViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Debug "
        view.backgroundColor = .black
        
        let desLabel = UILabel()
        desLabel.textColor = .white
        desLabel.font = .systemFont(ofSize: 20)
        desLabel.numberOfLines = 0
        desLabel.text = """
          name:     \(Device.App.displayName.unwrapped(or: ""))
          envi:        \(String(describing: Device.App.inferredEnvironment))
          version:   \(Device.App.version.unwrapped(or: ""))
          build:       \(Device.App.buildNumber.unwrapped(or: ""))
          serve:       \(Constants.Server.domainEnviroment)
          """
        view.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        let logoutBtn = UIButton(type: .system)
        logoutBtn.setTitle("log out", for: .normal)
        logoutBtn.titleLabel?.font = .systemFont(ofSize: 20)
        logoutBtn.addTarget(self, action:  #selector(logoutClick), for: .touchUpInside)
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { make in
            make.centerY.equalTo(desLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
//        let toolBtn = UIButton(type: .system)
//        let title = Constants.Doraemon.isOpen ? "Close Doraemon" : "Open Doraemon"
//        toolBtn.setTitle(title, for: .normal)
//        toolBtn.titleLabel?.font = .systemFont(ofSize: 20)
//        toolBtn.addTarget(self, action:  #selector(changeDoraemon), for: .touchUpInside)
//        view.addSubview(toolBtn)
//        toolBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(logoutBtn.snp.bottom).offset(30)
//            make.centerX.equalToSuperview()
//        }
        
        let serveBtn = UIButton(type: .system)
        let title = Constants.Server.domainEnviroment == .aws ? "open ali" : "Open aws"
        serveBtn.setTitle(title, for: .normal)
        serveBtn.titleLabel?.font = .systemFont(ofSize: 20)
        serveBtn.addTarget(self, action:  #selector(changeServe), for: .touchUpInside)
        view.addSubview(serveBtn)
        serveBtn.snp.makeConstraints { make in
            make.centerY.equalTo(logoutBtn.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        
        
    }
    
    @objc func logoutClick() {
        AccountManager.shared.logout()
    }
    
    @objc func changeServe() {
        AccountManager.shared.logout()
        if Constants.Server.domainEnviroment == .aws {
            Constants.Environment.ali.save()
        } else {
            Constants.Environment.aws.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exit(0)
        }
    }
    
}

