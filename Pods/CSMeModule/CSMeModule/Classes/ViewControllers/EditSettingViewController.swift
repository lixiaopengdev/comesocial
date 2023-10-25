//
//  EditSettingViewController.swift
//  CSMeModule
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
import CSMediator

class EditSettingViewController: BaseViewController {
    
    var listView = StaticListView()
    var cancellableSet = Set<AnyCancellable>()
    
    let numberCell = StaticNormalCellData(title: "Mobile Number", right: .detail(nil))
//    let emailCell = StaticNormalCellData(title: "Email", right: .detail(nil))
    
//    let passwordCell = StaticNormalCellData(title: "Password", right: .detail(nil))
//    let privacyCell = StaticNormalCellData(title: "Privacy Setting", right: .detail(nil))
//    let clearDataCell = StaticNormalCellData(title: "Clear Data", right: .detail(nil))
    let hiddenUserCell = StaticNormalCellData(title: "Hidden User", right: .detail(nil))
    
    let policyCell = StaticNormalCellData(title: "Privacy Policy", right: .detail(nil))
    let serviceCell = StaticNormalCellData(title: "Terms of Service", right: .detail(nil))
    let contactCell = StaticNormalCellData(title: "Contact Us", right: .detail(nil))
    let deleteAccountCell = StaticNormalCellData(title: "Delete My Account", right: .detail(nil))
    let logOutCell = StaticNormalCellData(title: "Log Out", right: .detail(nil))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        
        view.addSubview(listView)
        
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    
        numberCell.update(subtitle: MyProfileManager.share.user?.mobileDisplay)
        let sectionConnect = StaticTableViewSectionData(header: "Account", cells: [numberCell])
        let sectionPrivacy = StaticTableViewSectionData(header: "Privacy & Safety", cells: [hiddenUserCell])
        let sectionMore = StaticTableViewSectionData(header: "More", cells: [policyCell, serviceCell, contactCell, deleteAccountCell,logOutCell])
        listView.update(dataSource: [sectionConnect, sectionPrivacy, sectionMore])
        
        
        numberCell.update { [weak self] _ in
            self?.navigationController?.pushViewController(MyPhoneNumberViewController(), animated: true)
        }
        
        hiddenUserCell.update { _ in
            if let vc = Mediator.resolve(CSMediator.FriendsService.ViewControllerService.self)?.hiddenUserViewController() {
                Mediator.push(vc)
            }
        }
//        privacyCell.update { [weak self] _ in
//            self?.navigationController?.pushViewController(PrivacySettingViewController(), animated: true)
//        }
        //            self?.navigationController?.pushViewController(DebugViewController(), animated: true)

        policyCell.update { _ in
            let url = Constants.Server.baseURL + "/api/v0/privacy"
            Mediator.push(url)
        }
        serviceCell.update { _ in
            let url = Constants.Server.baseURL + "/api/v0/terms"
            Mediator.push(url)
        }
        contactCell.update { [weak self] _ in
            self?.navigationController?.pushViewController(ContactUsViewController(), animated: true)
        }
        logOutCell.update { [weak self] _ in
            self?.showlogoutAlert()
        }
        deleteAccountCell.update { [weak self] _ in
            self?.navigationController?.pushViewController(DeleteAccountViewController(), animated: true)
        }
        
   
//        Network.requestPublisher(UserService.settings).mapVoid().sink { _ in
//
//        } failure: { error in
//
//        }.store(in: &cancellableSet)

    }

    
    private func showlogoutAlert() {
        let alert = CSAlertController(title: "Are you sure you want to log out?", message: "Your session will end, and you will be logged out of your account.")
        let logoutAction = CSAlertController.Action(title: "Log Out", style: .red(cancel: true)) { action in
            AccountManager.shared.logout()
        }
        let cancelAction = CSAlertController.Action(title: "Cancel", style: .pure(cancel: true))
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, method: PresentTransitionMethod.centerIn)
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
}
