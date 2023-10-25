//
//  RobotModel.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/6/12.
//

import Foundation

public enum RobotMode {
    case InitMode
    case GoastMode
    case NormalMode
    case InField
    case Team
    case Ruly
    
    private static let goastSayings = ["Poof! You've disappeared from the radar.",
                               "Ghost Mode is on. You're now officially off the grid!",
                               "Welcome to Ghost Mode. No more tracking, no more posting.",
                               "And... Ghost Mode is engaged. Time to relax, you're incognito.",
                               "Going undercover, eh? Ghost Mode activated!",
                               "You've entered Ghost Mode. Enjoy your digital peace.",
                               "Now entering Ghost Mode. Your secrets are safe with me!",
                               "Shh... Ghost Mode initiated. You've become invisible.",
                               "Ghost Mode is live. You're off the social radar.",
                               "Hello, Ghost Mode! I promise, no peeking.",
                               "You're in Ghost Mode. Enjoy your time off the spotlight.",
                                ]
    
    private static let normalSayings = ["You're back on air! I'm all ears.",
                                "Good to have you back! Ready to capture your moments.",
                                "You're back in the game! Let's make some Dews.",
                                "Ready to join the social scene?",
                                "Back from the shadows! Ready to share the fun.",
                                "You're visible again! Let's start sharing.",
                                "Exiting Ghost Mode. Prepare to shine in the social sphere.",
                                "Welcome back! Ready to pick up where we left off?",
                                "Ghost Mode off. It's time to get social again.",
                                "You've stepped back into the light!",
                                "Hello again! Ready to record your experiences?",
                                "Welcome back from Ghost Mode. Let's make some memories.",
                                "Ready to feel the pulse of the party?",
                                "Back in action! Let's create some exciting Dews.",
                                "Ghost Mode deactivated. Ready to broadcast your adventures?",
                                "Rejoining the social scene! Your AI assistant is here to help.",
                                "Time to sync back up! You're back on the social radar.",
                                ]
    
    private static let inFeildSayings = ["Let's make this field more lively. How about inviting some friends?",
                                 "This field is big enough for more! Feel free to invite your buddies.",
                                 "More friends mean more fun. Would you like to invite more pals to this field?",
                                 "It's time to expand our circle. Shall we invite some friends to join us?",
                                 "Hey, let's spice up this field! How about inviting a few more friends?",
                                 "More the merrier! Would you like to invite more friends to our field?",
                                 "Feel like growing our field? Go ahead and invite your friends!",
                                 "Our field could use some more voices! How about inviting your pals?",
                                 "Remember, sharing is caring. Invite some friends to join our conversation",
                                 "Wouldn't this field be more fun with a few more friends? Feel free to invite them.",
                                 "This field is wide open! Let's invite some friends and start the fun.",
                                 "Fun is best shared! Want to invite some friends to our field?",
                                 "It's never too crowded in our field. How about inviting some buddies?",
                                 "Let's add more energy to this field. How about inviting your friends?",
                                 "Let's turn this field into a party. Want to invite more friends?",
                                 "Want to make this field more vibrant? Go ahead and invite your buddies.",
                                 "Our field is a friendly space. Feel free to invite more friends!",
                                 "We've got room for more! How about inviting some friends to join us?",
                                ]
    
    private static let teamSayings = ["Come Social Team is debating whether to display pictures in each Dew, and is talking about asking users for feedback.",
                              "Come Social Team is working hard on making the product, and has realized the potential risks of failing. LOL.",
                             ]
    
    private static let rulySayings = ["Ruly is sleeping, awaiting the sound of a beloved friend.",
                              "Ruly just finished updating its algorithms.",
                            ]
    
    
    var randomSaying: String {
        switch self {
        case .InitMode:
            return "Welcome to Come Social"
        case .GoastMode:
            return RobotMode.goastSayings[Int(arc4random()) % (RobotMode.goastSayings.count - 1)]
        case .NormalMode:
            return RobotMode.normalSayings[Int(arc4random()) % (RobotMode.normalSayings.count - 1)]
        case .InField:
            return RobotMode.inFeildSayings[Int(arc4random()) % (RobotMode.inFeildSayings.count - 1)]
        case .Team:
            return RobotMode.teamSayings[Int(arc4random()) % (RobotMode.teamSayings.count - 1)]
        case .Ruly:
            return RobotMode.rulySayings[Int(arc4random()) % (RobotMode.rulySayings.count - 1)]
        default:
            return "Welcome to Come Social"
        }
    }
}


