//
//  MapFragment.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/27.
//

import Foundation
import ObjectMapper
import CSUtilities
import UIKit
import Combine
import SwiftyJSON
import CSAccountManager
import CoreLocation
import CSSpyExpert
import CSMediator

class MapFragment: WidgetFragment {
    
    @Published var annotations: [CSAnnotation] = []
    var locationsData: JSON = JSON()
    var users: [FieldUserKit] = []
    
    override func initialize() {
        assembly
            .usersManager()
            .$users
            .sink { [weak self] users in
                self?.users = users
                self?.updateLocations()
            }
            .store(in: &cancellableSet)
    }
    
    override func update(full: JSON, change: JSON) {
        locationsData = full
        updateLocations()
    }
    
    private func syncLocation(_ location: CLLocationCoordinate2D) {
        let mineId = AccountManager.shared.id
        syncData(value: [String(mineId): ["latitude": location.latitude, "longitude": location.longitude, "avatar": Mediator.resolve(MeService.ProfileService.self)?.profile?.avatar]])
    }
    
    func updateLocations() {
        var newAnnotations: [CSAnnotation] = []
        for user in users {
            let uid = String(user.id)
            if let latitude = locationsData[uid]["latitude"].double,
               let longitude = locationsData[uid]["longitude"].double {
                
                // TODO: 国外不需要
                let newLocation = LocationTransform.wgs2gcj(wgsLat: latitude, wgsLng: longitude)
                newAnnotations.append(CSAnnotation(userId: uid, avatarUrl: locationsData[uid]["avatar"].stringValue, coordinate: CLLocationCoordinate2D(latitude: newLocation.gcjLat, longitude: newLocation.gcjLng)))
            }
        }
        annotations = newAnnotations
    }
    
    func uploadMyLocation() {
        let place = CSLocationManager.shared.getCurrentLocation()
        syncLocation(CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
    }
    
    override var height: CGFloat {
        
        return Device.UI.screenWidth - 15 * 2
    }
    
    
}
