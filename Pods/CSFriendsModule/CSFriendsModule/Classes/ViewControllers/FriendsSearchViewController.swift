//
//  FriendsSearchViewController.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/5/11.
//


import CSBaseView
import CSUtilities
import CSNetwork
import CSCommon
import Combine

class FieldSearchViewController: FriendSearchBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.bundleImage(named: "corner_add_light"), target: self, action: #selector(addClick))
        
    }
    
    override func search(text: String) {
        sendRequest(FriendService.search(name: text))
    }
    
    @objc func addClick() {
        navigationController?.pushViewController(FriendAddViewController(), animated: true)
    }
}
