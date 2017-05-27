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
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    private let manager = CLLocationManager()
    fileprivate var viewModel: DistanceViewModel? {
        didSet {
            distanceLabel.attributedText = viewModel?.attributedString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = 1
        
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
        
        let bishkekCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(42.874722),
                                                        longitude: CLLocationDegrees(74.612222))
        let bishkek = CLLocation(coordinate: bishkekCoordinates, altitude: 800, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
        
        //print("\(location.altitude) - \(bishkek.altitude)")
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
            self.viewModel = DistanceViewModel(distance: distance)
            print(distance)
        }
    }
}

