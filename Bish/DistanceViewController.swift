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

    public var city: City?
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard city != nil else {
            showNeedsCitySelection()
            return
        }
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
        guard let location = locations.first, let city = city else {
            return
        }

        let distance = location.distance(from: city.location)
        self.viewModel = DistanceViewModel(city: city, distance: distance)
    }

    private func showNeedsCitySelection() {
        let alertTitle = NSLocalizedString("No city selected", comment: "The title of the city selection required alert")
        let alertMessage = NSLocalizedString("Please select a city in the settings section", comment: "The message of the city selection required alert")
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("Ok", comment: "The button title to dismiss the city selection required alert")
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

