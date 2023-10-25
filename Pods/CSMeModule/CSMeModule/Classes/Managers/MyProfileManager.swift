//
//  ProfileUserViewModel.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/23.
//

import Foundation
import Combine
import CSNetwork
import CSUtilities
import CSAccountManager

public class MyProfileManager {
    
    public static let share = MyProfileManager()
    
    var userPublisher = CurrentValueSubject<UserModel?, Never>(nil)
    var collectionsPublisher = CurrentValueSubject<[CollectionModel]?, Never>(nil)

    var user: UserModel?
    var collections: [CollectionModel] = []

    private var editCancellable: AnyCancellable?
    
    func updateMyProfile() {
        Network.request(UserService.me, type: UserModel.self) { [weak self] model in
            self?.configUser(model)
        } failure: { error in
            HUD.showError(error)
        }
    }
    
    func updateCollections() {
        Network.request(UserService.collections, type: CollectionListModel.self) { [weak self] model in
            self?.configCollections(model.lifeFlow)
        } failure: { error in
            HUD.showError(error)
        }
    }
    
    private func configUser(_ userModel: UserModel) {
        user = userModel
//        AccountManager.shared.updateInfo(name: userModel.name, avatar: userModel.thumbnailUrl ?? "", field: userModel.privateFieldId ?? userModel.currentFieldId ?? 0)
        
        userPublisher.send(userModel)
    }
    
    private func configCollections(_ collections: [CollectionModel]) {
        self.collections = collections
        collectionsPublisher.send(collections)
    }
   
    func editProfile(type: MyProfileEditType, success: @escaping Action, failure: @escaping Action1<NetworkError>) {
        editCancellable = Network.requestPublisher(UserService.edit(type: type)).mapVoid().sink(success: { [weak self] _ in
            self?.updateMyProfile()
            success()
        }, failure: failure)
  
    }
}

enum MyProfileEditType {
    case name(String)
    case userName(String)
    case birthday(String)
    case school(String)
    case bio(String)
    
    func mapValue(_ value: String) -> MyProfileEditType{
        switch self {
        case .name:
            return .name(value)
        case .userName:
            return .userName(value)
        case .birthday:
            return .birthday(value)
        case .school:
            return .school(value)
        case .bio:
            return .bio(value)
        }
    }
    
    var content: String {
        switch self {
        case .name(let value):
            return value
        case .userName(let value):
            return value
        case .birthday(let value):
            return value
        case .school(let value):
            return value
        case .bio(let value):
            return value
        }
    }
    
    var title: String {
        switch self {
        case .name:
            return "name"
        case .userName:
            return "Username"
        case .birthday:
            return "Birthday"
        case .school:
            return "School"
        case .bio:
            return "Bio"
        }
    }
    
    var apiKey: String {
        switch self {
        case .name:
            return "name"
        case .userName:
            return "usernameID"
        case .birthday:
            return "birthday"
        case .school:
            return "school"
        case .bio:
            return "bio"
        }
    }
}


 
