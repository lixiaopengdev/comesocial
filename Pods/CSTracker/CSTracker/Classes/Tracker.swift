//
//  Tracker.swift
//  CSTracker
//
//  Created by 于冬冬 on 2023/6/26.
//

import Mixpanel

public class Tracker {
    
    private static var tracker: MixpanelInstance {
        return Mixpanel.mainInstance()
    }
    
    public static func initialize(token apiToken: String) {
        Mixpanel.initialize(token: apiToken, trackAutomaticEvents: true)
#if DEBUG
        tracker.loggingEnabled = true
#endif
        tracker.serverURL = "https://api-eu.mixpanel.com"
    }
    
    public static func track(event: String?, properties: Properties? = nil) {
        tracker.track(event: event, properties: properties)
    }
    
    public static func track(event: Event?, properties: Properties? = nil) {
        tracker.track(event: event?.rawValue, properties: properties)
    }
    
    public static func time(event: String) {
        tracker.time(event: event)
    }

    public static func time(event: Event) {
        tracker.time(event: event.rawValue)
    }
    
    public static func registerSuperProperties(_ properties: Properties) {
        tracker.registerSuperProperties(properties)
    }
    
    public static func registerSuperPropertiesOnce(_ properties: Properties,
                                                   defaultValue: MixpanelType? = nil) {
        tracker.registerSuperPropertiesOnce(properties, defaultValue: defaultValue)
    }
    
    public static func setProfile(properties: Properties) {
        tracker.people.set(properties: properties)
    }
    
    public static func incrementProfile(properties: Properties) {
        tracker.people.increment(properties: properties)
    }
    
    public static func login(uid: UInt) {
        tracker.identify(distinctId: String(uid))
    }
    
    public static func logout() {
        tracker.reset()
    }
    
}
