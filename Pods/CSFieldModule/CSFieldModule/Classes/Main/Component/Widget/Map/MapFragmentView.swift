//
//  MapFragmentView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/27.
//

import CSAccountManager
import Combine
import CSUtilities

class MapFragmentView: WidgetFragmentView {
    
    let mapView = CSMapView()
    
    var mapFragment: MapFragment {
        return fragment as! MapFragment
    }
    
    override func initialize() {
        
        mapView.layerCornerRadius = 16
        
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))
        }
        mapView.setup(withAnnotations: [])
        mapFragment.$annotations
            .sink { [weak self] annotations in
                self?.mapView.update(withAnnotations: annotations)
            }
            .store(in: &cancellableSet)
        mapFragment.uploadMyLocation()
    }
}
