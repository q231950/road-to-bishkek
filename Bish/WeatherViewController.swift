//
//  WeatherViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 27.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class WeatherViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    let weatherProvider = WeatherProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
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
        fetchRequest.predicate = NSPredicate(format: "selected == true")
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataStore.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Weather")
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
        updateView()
    }

    private func updateView() {
        guard let city = fetchedResultsController.fetchedObjects?.first else {
            return
        }

        if let identifier = city.geonameid {
            let cityLocation = CLLocation(latitude: city.latitude, longitude: city.longitude)
            let cityModel = City(identifier:identifier, countryCode: city.countryCode ?? "", name: city.name ?? "", location: cityLocation)
            updateView(city: cityModel)
        }
    }

    private func updateView(city: City) {
        weatherProvider.weather(in: city) { (weatherViewModel: WeatherViewModel?, error: Error?) in
            DispatchQueue.main.async {
                self.textView.attributedText = weatherViewModel?.text
            }
        }
    }
}
