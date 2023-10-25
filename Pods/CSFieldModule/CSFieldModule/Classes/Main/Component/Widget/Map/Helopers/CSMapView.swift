
import Foundation
import MapKit
import SnapKit
import Kingfisher


public class CSAnnotation: NSObject, MKAnnotation {
    public var userId: String
    public var avatarUrl: String
    public var coordinate: CLLocationCoordinate2D
    public init(userId: String ,avatarUrl: String, coordinate: CLLocationCoordinate2D) {
        self.userId = userId
        self.avatarUrl = avatarUrl
        self.coordinate = coordinate
    }
}


public class CSAnnotationView: MKAnnotationView {
        
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.bkView)
        self.addSubview(self.avatarView)

        self.bkView.snp.makeConstraints { make in
            make.width.equalTo(46)
            make.height.equalTo(49)
        }
        self.avatarView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(38)
            make.centerX.equalTo(self.bkView.snp.centerX)
            make.centerY.equalTo(self.bkView.snp.centerY).offset(-2)
        }
        self.avatarView.layer.cornerRadius = 19
        self.avatarView.layer.masksToBounds = true
    }
    
    public lazy var bkView: UIImageView = {
        let bkView = UIImageView()
        bkView.backgroundColor = .clear
        return bkView
    }()
    
    public lazy var avatarView: UIImageView = {
       let avatarView = UIImageView()
        avatarView.backgroundColor = .clear
        avatarView.isUserInteractionEnabled = false
        return avatarView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class CSMapView: MKMapView {
//	fileprivate weak var generalDelegate: CSMapViewDelegate?
	
	fileprivate let pinID = "_CSMapViewPinID"
		
	open override var delegate: MKMapViewDelegate? {
		get {
			return super.delegate
		}
		set(delegate) {
			guard let delegate = delegate else { return }
//			generalDelegate = delegate as? CSMapViewDelegate
			super.delegate = self
		}
	}
	
	open func setup(withAnnotations annotations: [CSAnnotation]) {
        self.delegate = self
		DispatchQueue.main.async {
			for annotation in annotations {
				self.addAnnotation(annotation)
			}
            self.showAnnotations(annotations, animated: true)
		}
	}
    
    func update(withAnnotations annotations: [CSAnnotation]) {
        self.removeAnnotations(self.annotations)
        self.showAnnotations(annotations, animated: true)
    }
    
    public func removeUser(userId: String) {
        for cs_annotation in self.annotations {
            if userId == (cs_annotation as! CSAnnotation).userId {
                self.removeAnnotation(cs_annotation)
                break
            }
        }
    }
    
    public func addUser(cs_annotation: CSAnnotation) {
        self.addAnnotation(cs_annotation)
    }
}

extension CSMapView: MKMapViewDelegate {
	
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = self.dequeueReusableAnnotationView(withIdentifier: pinID) as? CSAnnotationView
        if annotationView == nil{
            annotationView = CSAnnotationView(annotation: annotation, reuseIdentifier: pinID)
            annotationView?.canShowCallout = false
        }
        
        annotationView?.annotation = annotation
        annotationView?.bkView.image = UIImage.bundleImage(named: "map_av")
        let imageUrl = URL.init(string:(annotation as! CSAnnotation).avatarUrl)
        
        DispatchQueue.main.async {
            annotationView?.avatarView.kf.setImage(with: imageUrl, placeholder: nil)
        }
        annotationView?.frame = CGRectMake(0, 0, 46, 49)
		return annotationView
	}
	
	open func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if view.annotation is MKUserLocation { return }
		// generalDelegate?.mapView?(self, didSelect: view)
	}
	
	open func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		if view.annotation is MKUserLocation { return }
		// generalDelegate?.mapView?(self, didDeselect: view)
	}
}
