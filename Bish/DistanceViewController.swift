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
    
    private let kBigTextFontSize: CGFloat = 60
    private let kBigTextFontName: String = "Menlo-Bold"
    private let kSmallTextFontSize: CGFloat = 32
    private let kSmallTextFontName: String = "Menlo"
    
    private let manager = CLLocationManager()
    @IBOutlet weak var distanceLabel: UILabel!
    
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
    
    fileprivate func updateWith(_ distance: CLLocationDistance) {
        
        let combinedString = NSMutableAttributedString()
        
        let kilometers = attributedKilometersStringWith(distance)
        combinedString.append(kilometers)
        
        let meters = attributedMetersStringWith(distance)
        combinedString.append(meters)
        
        let centimeters = attributedCentimetersStringWith(distance)
        combinedString.append(centimeters)
        
        let city = attributedCityString(name: "Bishkek")
        combinedString.append(city)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
        combinedString.addAttributes(attributes, range: NSMakeRange(0, combinedString.length))

        distanceLabel.attributedText = combinedString
    }
    
    private func attributedKilometersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "kilometers", value: Int(distance.divided(by: 1000).rounded(.up)))
    }
    
    private func attributedMetersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "meters", value: Int(distance.truncatingRemainder(dividingBy: 1000)))
    }
    
    private func attributedCentimetersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "centimeters", value: Int(distance.multiplied(by: 100).truncatingRemainder(dividingBy: 100)))
    }
    
    private func bigTextAttributes() -> [String: Any] {
        return  [NSFontAttributeName: UIFont.init(name: kBigTextFontName, size: kBigTextFontSize)!,
                 NSForegroundColorAttributeName: UIColor.white]
    }
    
    private func smallTextAttributes() -> [String: Any] {
        return [NSFontAttributeName: UIFont.init(name: kSmallTextFontName, size: kSmallTextFontSize)!,
                NSForegroundColorAttributeName: UIColor.white]
    }

    private func attributedUnitString(unit: String, value: Int) -> NSAttributedString {
        
        let valueString = NSAttributedString(string: "\(value)", attributes: bigTextAttributes())
        let unitString = NSAttributedString(string: "\(unit)", attributes: smallTextAttributes())
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(valueString)
        combinedString.append(unitString)
        return combinedString
    }
    
    private func attributedCityString(name: String) -> NSAttributedString {
        let valueString = NSAttributedString(string: "to", attributes: smallTextAttributes())
        let unitString = NSAttributedString(string: "\(name)", attributes: bigTextAttributes())
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(valueString)
        combinedString.append(unitString)
        return combinedString
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
            updateWith(distance)
            print(distance)
        }
    }
}

