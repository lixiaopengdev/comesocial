//
//  MeProfileServiceImp.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator
import Combine

class MeProfileServiceImp: MeProfileService {
    
    @Published var profile: MeProfileInfo?
    private var cancellableSet = Set<AnyCancellable>()

    
    class MeProfile: MeProfileInfo {
        let name: String
        let avatar: String?
        let fieldId: UInt?
        
        init(name: String, avatar: String?, fieldId: UInt?) {
            self.name = name
            self.avatar = avatar
            self.fieldId = fieldId
        }
    }
    
    init() {
        MyProfileManager.share
            .userPublisher
            .map({ user -> MeProfile?  in
                guard let user else { return nil }
                return MeProfile(name: user.name, avatar: user.thumbnailUrl, fieldId: user.currentFieldId)
            })
            .sink { [weak self] profile in
                self?.profile = profile
            }
            .store(in: &cancellableSet)
    }

    
    func profileUpdatePublisher() -> AnyPublisher<CSMediator.MeService.ProfileInfo?, Never> {
        return $profile.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
    
}
