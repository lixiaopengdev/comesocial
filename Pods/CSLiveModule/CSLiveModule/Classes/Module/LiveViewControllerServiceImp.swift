//
//  Live.swift
//  CSLiveModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator

struct LiveViewControllerServiceImp: LiveViewControllerService {
    func homeViewController() -> UIViewController {
        return LiveViewController()
    }
    
    func shareTimeDewViewController(titleText: String, contentText: String, photoImageURL: String?, contentImageURL: String?) -> UIViewController {
        return LifeFlowShareViewController(titleText: titleText, contentText: contentText, shareURL: "https://github.com/NeoWorldTeam", photoImageURL: photoImageURL, contentImageURL: contentImageURL)
    }
    
    func moreFunction(requestSessionId: String, timeDewId: UInt, timeDewType: String, isSaveTimeDew: String?) -> UIViewController {
        return MoreViewController(requsestSessionID: requestSessionId, timeDewId: timeDewId, timeDewType: timeDewType, isSaveTimeDew: isSaveTimeDew)
    }
    
}
