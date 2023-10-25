//
//  FieldAddViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/15.
//

import CSBaseView
import CSUtilities
import CSNetwork
//import CSRouter
import CSCommon
import Combine
import CSListView
import IGListKit

class FriendAddViewController: FriendSearchBaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func search(text: String) {
        sendRequest(FriendService.addSearch(name: text))
    }
    
}
