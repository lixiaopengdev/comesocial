//
//  SettingsViewController.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/5/29.
//

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation
import CSSpyExpert

class SettingsViewController : BaseViewController {
    var listView = StaticListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Time Dew Setting"
        navigationItem.hidesBackButton = false
        navigationItem.largeTitleDisplayMode = .automatic
        
        view.addSubview(listView)
        
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    
        let locationCell = StaticNormalCellData(title: "Location", right: .switchBtn(isOn: SpyExpert.shared.hasPushInfo(info: .location), action: { isOn in
            if isOn {
                SpyExpert.shared.openPushInfo(info: .location)
            }else {
                SpyExpert.shared.closePushInfo(info: .location)
            }
        }))
        
        let microphoneCell = StaticNormalCellData(title: "Microphone", right: .switchBtn(isOn: SpyExpert.shared.hasPushInfo(info: .microphone), action: { isOn in
            if isOn {
                SpyExpert.shared.openPushInfo(info: .microphone)
            }else {
                SpyExpert.shared.closePushInfo(info: .microphone)
            }
        }))

        let sectionInside = StaticTableViewSectionData(header: nil, cells: [locationCell, microphoneCell])
        
        
        listView.dataSource = [sectionInside]
        
        let saveButton = UIButton()
        view.addSubview(saveButton)

        saveButton.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        saveButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(95)
            make.right.equalToSuperview().offset(-95)
            make.bottom.equalToSuperview().offset(-52)
        }
        guard let url = Bundle(for: LiveViewController.self).url(forResource: "CSLiveModule", withExtension: "bundle") else {
            return
        }
        let localBundle = Bundle(url: url)
        saveButton.setImage(UIImage(named: "save_button", in: localBundle, compatibleWith: nil), for: .normal)
    }
    
    
    @objc
    fileprivate func saveClick(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
}
