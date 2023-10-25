//
//  LiveTimeDewServiceImp.swift
//  CSLiveModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSNetwork
import CSMediator

struct LiveTimeDewServiceImp: LiveTimeDewService {
    
    func editlSaveTimeDew(id: Int, type: String, editHandle: Int) {
        
        if editHandle == 1 {
            Network.oriRequest(LifeFlowService.save(id: Int(id), type: type), completion:  { result in
                print("save: \(result)")
                switch result {
                case .success(_):
                    break
                    
                case .failure(_):
                    break
                }
            })
        }else{
            Network.oriRequest(LifeFlowService.cancelSave(id: id, type: type), completion:  { result in
                print("cancel save: \(result)")
                switch result {
                case .success(_):
                    break
                    
                case .failure(_):
                    break
                }
            })
        }
        
    }
    

    
    func doReactionTimeDew(id: Int, type: String, editHandle: Int) {
        if editHandle == 1 {
            Network.oriRequest(LifeFlowService.addReaction(id: id, type: type), completion:  { result in
                print("addReaction: \(result)")
                switch result {
                case .success(_):
                    break

                case .failure(_):
                    break
                }
            })
        }else{
            Network.oriRequest(LifeFlowService.deleteReaction(id: id, type: type), completion:  { result in
                print("deleteReaction: \(result)")
                switch result {
                case .success(_):
                    break
                    
                case .failure(_):
                    break
                }
            })
        }
    }
    
    func jumpFieldTimeDew(fieldId: UInt) {
        Network.oriRequest(LifeFlowService.jumpToField(fieldID: Int(fieldId)), completion:  { result in
            print("jumpToField: \(result)")
            switch result {
            case .success(_):
                break
                
            case .failure(_):
                break
            }
        })
    }
    
    func inviteJoinField(inviteUserId: UInt) {
        Network.oriRequest(LifeFlowService.invite_join_field(user_id: inviteUserId), completion:  { result in
            print("invite user save: \(result)")
            switch result {
            case .success(_):
                break
                
            case .failure(_):
                break
            }
        })
    }
    
    
    func cancelSaveTimeDew(id: Int, type: String) {
        Network.oriRequest(LifeFlowService.cancelSave(id: id, type: type), completion:  { result in
            print("cancel save: \(result)")
            switch result {
            case .success(_):
                break
                
            case .failure(_):
                break
            }
        })
    }
}
