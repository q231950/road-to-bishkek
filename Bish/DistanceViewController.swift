//
//  ViewController.swift
//  GeoMe
//
//  Created by Martin Kim Dung-Pham on 25.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit
import CoreLocation

class DistanceViewController: UIViewController {
    
    private let manager = CLLocationManager()
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = 10
        
        handleCurrentLocationAuthorizationStatus(CLLocationManager.authorizationStatus())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func handleCurrentLocationAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            print("status is \(status)")
        }
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    fileprivate func distanceToBishkek(location: CLLocation) -> CLLocationDistance {
        let bishkek = CLLocation(latitude: CLLocationDegrees(42.874722),
                                 longitude: CLLocationDegrees(74.612222))
        return location.distance(from: bishkek)
    }
}

extension DistanceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("locationManager authorization status is now")
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let distance = distanceToBishkek(location: location)
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            let attributes = [NSFontAttributeName: UIFont.init(name: "Menlo-Bold", size: 19)!,
                              NSForegroundColorAttributeName: UIColor.white]
            let paragraph = NSAttributedString(string: "\(distance/1000) km to Bishkek", attributes: attributes)
            distanceLabel.attributedText = paragraph
        }
    }
}

