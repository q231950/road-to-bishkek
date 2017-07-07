//
//  DataStore.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 03.07.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import CoreData

class DataStore {

    public static let shared = DataStore()

    public func createCity(_ city: City) throws -> CityManagedObject {
        let cityManagedObject = NSManagedObject(entity: CityManagedObject.entity(),
                                                insertInto: persistentContainer.viewContext) as! CityManagedObject
        cityManagedObject.name = city.name
        cityManagedObject.geonameid = city.identifier
        cityManagedObject.latitude = city.location.coordinate.latitude
        cityManagedObject.longitude = city.location.coordinate.longitude

        saveContext()
        return cityManagedObject
    }

    public func select(_ city: City) throws {
        let cityManagedObject = try managed(city)
        cityManagedObject.selected = !cityManagedObject.selected
    }

    public func deselectAllCities() throws {
        if let name = CityManagedObject.entity().name {
            let request = NSFetchRequest<CityManagedObject>(entityName: name)
            let storeResult = try persistentContainer.viewContext.fetch(request)
            storeResult.forEach({ (cityManagedObject) in
                cityManagedObject.selected = false
            })
        }
    }

    public func managed(_ city: City) throws -> CityManagedObject {
        if let cityManagedObject = try cityManagedObjectWithGeoNameIdentifier(city.identifier) {
            return cityManagedObject
        } else {
            return try DataStore.shared.createCity(city)
        }
    }

    public func cityManagedObjectWithGeoNameIdentifier(_ identifier: String) throws -> CityManagedObject? {
        if let name = CityManagedObject.entity().name {
            let request = NSFetchRequest<CityManagedObject>(entityName: name)
            request.predicate = NSPredicate(format: "geonameid == '\(identifier)'")
            let storeResult = try persistentContainer.viewContext.fetch(request)
            return storeResult.first
        }

        return nil
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BishDataModel") //BishDataModel
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
