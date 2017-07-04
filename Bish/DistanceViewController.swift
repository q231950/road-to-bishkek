//
//  ViewController.swift
//  GeoMe
//
//  Created by Martin Kim Dung-Pham on 25.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class DistanceViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!

    public var city: CityManagedObject?
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

        city = fetchedResultsController.fetchedObjects?.first

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

    var fetchedResultsController: NSFetchedResultsController<CityManagedObject> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let fetchRequest: NSFetchRequest<CityManagedObject> = CityManagedObject.fetchRequest()

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataStore.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Distance")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController

        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<CityManagedObject>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        city = fetchedResultsController.fetchedObjects?.filter({ (city) -> Bool in
            return city.selected == true
        }).first

        guard let location = manager.location, let city = city else {
            return
        }

        updateView(location: location, city: city)
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

        updateView(location: location, city: city)
    }

    private func updateView(location: CLLocation, city: CityManagedObject) {
        let cityLocation = CLLocation(latitude: city.latitude, longitude: city.longitude)
        let distance = location.distance(from: cityLocation)
        if let identifier = city.geonameid {
            let cityModel = City(identifier:identifier, name: city.name ?? "", location: cityLocation)
            self.viewModel = DistanceViewModel(city: cityModel, distance: distance)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showErrorWhileRetrievingLocation()
    }

    private func showErrorWhileRetrievingLocation() {
        let alertTitle = NSLocalizedString("Error", comment: "The title of the alert when the location could not be retrieved")
        let alertMessage = NSLocalizedString("Unable to retrieve location", comment: "The message the alert when the location could not be retrieved")
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("Ok", comment: "The button title to dismiss the alert when the location could not be retrieved")
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
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

