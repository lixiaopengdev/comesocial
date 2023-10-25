//
//  WidgetLayer.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/3.
//

import UIKit
import CSRobotView

class WidgetLayer: FieldBaseView {
    
    let robotView = CSRobotView()
    
     var container: WidgetContainerView{
         assembly.resolve()
     }
    
    override func initialize() {
        addSubview(container)
        addSubview(robotView)
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        robotView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.bottom.equalTo(-26)
            make.right.equalTo(-20)
        }
        
        robotView.setState(state: .state_normal)
        robotView.setScene(state: .InField)
    }
    
//    func getRulyText() -> String {
//        let messages = [
//            "Let's make this field more lively. How about inviting some friends?",
//            "This field is big enough for more! Feel free to invite your buddies.",
//            "More friends mean more fun. Would you like to invite more pals to this field?",
//            "It's time to expand our circle. Shall we invite some friends to join us?",
//            "Hey, let's spice up this field! How about inviting a few more friends?",
//            "More the merrier! Would you like to invite more friends to our field?",
//            "Feel like growing our field? Go ahead and invite your friends!",
//            "Our field could use some more voices! How about inviting your pals?",
//            "Remember, sharing is caring. Invite some friends to join our conversation.",
//            "Wouldn't this field be more fun with a few more friends? Feel free to invite them.",
//            "This field is wide open! Let's invite some friends and start the fun.",
//            "Fun is best shared! Want to invite some friends to our field?",
//            "It's never too crowded in our field. How about inviting some buddies?",
//            "Let's add more energy to this field. How about inviting your friends?",
//            "Let's turn this field into a party. Want to invite more friends?",
//            "Want to make this field more vibrant? Go ahead and invite your buddies.",
//            "Our field is a friendly space. Feel free to invite more friends!",
//            "We've got room for more! How about inviting some friends to join us?"
//        ]
//
//        return messages[Int.random(in: 0 ..< messages.count)]
//
//    }
}


