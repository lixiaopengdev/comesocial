//
//  NotifacationSettingViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/10.
//

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation

class PrivacySettingViewController: BaseViewController {
    
    var listView = StaticListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Privacy Setting"
        
        view.addSubview(listView)
        
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    
        let onlineCell = StaticNormalCellData(title: "Friends Online", subtitle: "Friends with relationships will not be influenced ", right: .switchBtn(isOn: true, action: { isOn in
            print(isOn)
        }))
        let timeDewCell = StaticNormalCellData(title: "Time Dew from Friends", subtitle: "Get occasional notifications about your friends' time dews. Friends with relationships will not be influenced.  ", right: .switchBtn(isOn: true, action: { isOn in
            print(isOn)
        }))
        
        let sectionInside = StaticTableViewSectionData(header: "Inside Ruleless", cells: [onlineCell, timeDewCell])
        
        /// ================
        let deatilCell = StaticNormalCellData(title: "Detailed Notification", right: .switchBtn(isOn: false, action: { isOn in
            print(isOn)
        }))
        let receiveCell = StaticNormalCellData(title: "Receive Field Invitation", right: .switchBtn(isOn: true, action: { isOn in
            print(isOn)
        }))
        let sectionOutside = StaticTableViewSectionData(header: "Inside Ruleless", cells: [deatilCell, receiveCell])
        
        listView.dataSource = [sectionInside, sectionOutside]
        
        
 
        
    }

    
    override var backgroundType: BackgroundType {
        return .dark
    }
}
