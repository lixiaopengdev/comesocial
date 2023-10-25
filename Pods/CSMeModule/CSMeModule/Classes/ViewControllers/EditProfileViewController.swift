//
//  EditProfileViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/8.
//

import CSBaseView
import SnapKit
import CSAccountManager
import CSUtilities
import Foundation
import Combine
import CSCommon
import CSFileKit
import CSNetwork

class EditProfileViewController: BaseViewController {
    
    private var cancellableSet = Set<AnyCancellable>()
    
    var listView = StaticListView()
    var editAvatarView = EditAvatarView(frame: CGRect(x: 0, y: 0, width: Device.UI.screenWidth, height: 125))
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .boldBody
        button.setTitleColor(.cs_pureWhite, for: .normal)
        button.setBackgroundImage(UIImage.bundleImage(named: "gradient_button_rect"), for: .normal)
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return button
    }()
    let nameCell = StaticNormalCellData(title: "Name")
    let userNameCell = StaticNormalCellData(title: "UserName")
    let birthdayCell = StaticNormalCellData(title: "Birthday")
    let schoolCell = StaticNormalCellData(title: "School")
    let bioCell = StaticEditTextCellData(title: "Bio")
    
    var user: UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit Profile"
        
        view.addSubview(listView)
        view.addSubview(saveBtn)
        
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        saveBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 48))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        MyProfileManager.share.userPublisher
            .sink { [weak self] user in
                self?.updateUser(user)
            }
            .store(in: &cancellableSet)
        
        let section = StaticTableViewSectionData(header: nil, cells: [nameCell, userNameCell, birthdayCell, schoolCell, bioCell])
        listView.update(dataSource: [section])
        listView.tableView.tableHeaderView = editAvatarView
        
        editAvatarView.avatarTappedHandler = {[weak self] in
            guard let self = self else { return }
            let vc = ImagePicker.configPicker { image in
                self.updateAvatar(image)
            }
            self.present(vc, animated: true)
        }
        bioCell.updateEndEdit { [weak self] _ in
            self?.updateBio()
        }
    }
    
    func updateAvatar(_ image: UIImage?) {
        guard let image = image else { return }
        HUD.show()
        FileTask
            .saveImage(image: image)
            .mapError { fileError in
                return NetworkError.undefined(0, "image error")
            }
            .flatMap { url in
                return Network.requestPublisher(UserService.avatar(url: url)).mapVoid()
            }
            .sink { _ in
                HUD.dismiss()
                MyProfileManager.share.updateMyProfile()
            } failure: { error in
                HUD.showError(error)
            }
            .store(in: &cancellableSet)
    }
    
    func updateUser(_ user: UserModel?) {
        self.user = user
        guard let user = user else { return }
        nameCell.update(right: .text(user.name)) { [weak self] _ in
            let editVC = EditTextFieldViewController(type: .name(user.name))
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        userNameCell.update(right: .text(user.systemName)) { [weak self] _ in
            let editVC = EditTextFieldViewController(type: .userName(user.systemName))
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        
        let date = Date(string: user.birthday ?? "", withFormat: "yyyyMMdd")

        let birthday: String = date?.string(withFormat: "yyyy.MM.dd") ?? ""
        birthdayCell.update(right: birthday.isEmpty ? .detail(nil) : .text(birthday)) { [weak self] _ in
            let datePickerVC = BirthdayDatePickerViewController()
            if let date = date {
                datePickerVC.selectedDate = date
            }
            datePickerVC.selectedDateCallBack = {[weak self] date in
                self?.updateBirthday(date: date)
            }
            self?.present(datePickerVC, method: PresentTransitionMethod.bottomToTop(height: 290))
        }
        schoolCell.update(right: user.schoolName.isNilOrEmpty ? .detail(nil) : .text(user.schoolName ?? "")) { [weak self] _ in
            let editVC = EditTextFieldViewController(type: .school(user.schoolName ?? ""))
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        bioCell.update(content: user.bio)
        editAvatarView.update(avatar: user.thumbnailUrl)
    }
    
    
    func updateBio() {
        if bioCell.cellContent != user?.bio {
            MyProfileManager.share.editProfile(type: .bio(bioCell.cellContent ?? "")) {
                
            } failure: { arg in
                
            }
        }
    }
    
    func updateBirthday(date: Date) {
        let birthday = date.string(withFormat: "yyyyMMdd")
        MyProfileManager.share.editProfile(type: .birthday(birthday)) {
            
        } failure: { arg in
            
        }
    }
    
    @objc func saveClick() {
        
        if bioCell.cellContent != user?.bio {
            HUD.show()
            MyProfileManager.share.editProfile(type: .bio(bioCell.cellContent ?? "")) {
                HUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            } failure: { arg in
                HUD.showError(arg)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
    deinit {
        print("EditProfileViewController deinit")
    }
}


