//
//  TrackerEvent+Root.swift
//  ComeSocialRootModule
//
//  Created by 于冬冬 on 2023/6/27.
//

import CSTracker


extension Tracker.Event {
    static let openApp: Tracker.Event = "Open App"
    static let appInBackground: Tracker.Event = "App in Background"
    static let enterFriendsTab: Tracker.Event = "Enter Friends Tab"
    static let exitFriendsTab: Tracker.Event = "Exit Friends Tab"
    static let exitMeTab: Tracker.Event = "Exit Me Tab"
    static let enterMeTab: Tracker.Event = "Enter Me Tab"

}
