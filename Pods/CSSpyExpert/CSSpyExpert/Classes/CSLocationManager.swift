//
//  CSLocationManager.swift
//  FlowYourLife
//
//  Created by fuhao on 2023/3/28.
//

import Foundation
import CoreLocation


public struct PlaceMark : Codable{
    var timeStamp: Int64 = 0
    public internal(set) var longitude: Double = 0
    public internal(set) var latitude: Double = 0
    var name: String
    var thoroughfare: String
    var locality: String
    var subAdministrativeArea: String
    var administrativeArea: String
    var postalCode: String
    var country: String
}



public typealias OnLocationUpdate = (PlaceMark?) -> Void


public class CSLocationManager : NSObject {
    public static let shared = CSLocationManager()
    private override init() {
        super.init()
        _locationManager.delegate = self
    }
    
    lazy var _locationManager = CLLocationManager()
    var _locationCache: PlaceMark = PlaceMark(name: "", thoroughfare: "", locality: "", subAdministrativeArea: "", administrativeArea: "", postalCode: "", country: "")
    var _onLocationUpdates: [OnLocationUpdate] = []
    var _isUpdatingLocation = false

    
    var _tryTiems = 3
    
    public func requestCurrentLocation(_ onLocationUpdate: OnLocationUpdate?) {
        
        if let onLocationUpdate = onLocationUpdate {
            _onLocationUpdates.append(onLocationUpdate)
        }
        
        
        guard _isUpdatingLocation == false else {
            return
        }
        print("开启定位")
        _tryTiems = 3
        _isUpdatingLocation = true
        _locationManager.startUpdatingLocation()
    }
    
    public func getCurrentLocation() -> PlaceMark{
        return _locationCache
    }
    
    func stopUpdateLocation() {
        guard _isUpdatingLocation else {
            return
        }
        print("停止定位")
        _isUpdatingLocation = false
        _locationManager.stopUpdatingLocation()
    }
    
    func updateLocation(plackMask: PlaceMark?) {
        if let plackMask = plackMask {
            _locationCache = plackMask
        }
        _onLocationUpdates.forEach { onLocationUpdate in
            onLocationUpdate(_locationCache ?? nil)
        }
        _onLocationUpdates.removeAll()
    }
    
    func handleLocationDecode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed:\(error.localizedDescription)")
                self?.updateLocation(plackMask: nil)
                return
            }
            
            
            guard let placemark = placemarks?.first else {
                return
            }
            print("停止定位，并更新地址： 国家：\(placemark.country ?? ""),城市：\(placemark.locality ?? ""),区域：\(placemark.subLocality ?? ""),街道：\(placemark.thoroughfare ?? ""),门牌号：\(placemark.subThoroughfare ?? ""),名称:\(String(describing: placemark.name))")

            
            var place = PlaceMark(timeStamp: Int64(Date().timeIntervalSince1970 * 1000), longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, name: placemark.name ?? "", thoroughfare: placemark.thoroughfare ?? "", locality: placemark.locality ?? "", subAdministrativeArea: placemark.subAdministrativeArea ?? "", administrativeArea: placemark.administrativeArea ?? "", postalCode: placemark.postalCode ?? "", country: placemark.country ?? "")
            
            self?.updateLocation(plackMask: place)
        }
    }
}




//MARK: - 坐标的回调
extension CSLocationManager : CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("获取位置结果")
        guard _isUpdatingLocation else {
            return
        }
        
        guard let location = locations.last else {
            _tryTiems -= 1
            if _tryTiems < 0 {
                stopUpdateLocation()
                updateLocation(plackMask: nil)
            }
            return
        }
        stopUpdateLocation()
        handleLocationDecode(location: location)
    }
}

