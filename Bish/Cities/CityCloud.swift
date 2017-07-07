//
//  CityCloud.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 16.06.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import Foundation
import CloudKit

public class CityCloud {

    public func citiesNamed(_ name: String, completion: @escaping (([City]?, Error?) -> Void)) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let predicate = NSPredicate(format: "self CONTAINS '\(name)'")
            let query = CKQuery(recordType: "City", predicate: predicate)
            let countrySortDescriptor = NSSortDescriptor(key: "countrycode", ascending: true)
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            query.sortDescriptors = [nameSortDescriptor, countrySortDescriptor]


            let database = CKContainer.default().publicCloudDatabase
            database.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) in
                if let error = error {
                    print(error)
                }
                
                let cities = records?.map({ (record: CKRecord) -> City in
                    let name: String
                    if let n = record.object(forKey: "name") as? String {
                        name = n
                    } else {
                        name = NSLocalizedString("n/a", comment: "The name of a city when the name is not available")
                    }

                    let countryCode: String
                    if let c = record.object(forKey: "countrycode") as? String {
                        countryCode = c
                    } else {
                        countryCode = NSLocalizedString("n/a", comment: "The country code of a city when the code is not available")
                    }

                    let location: CLLocation
                    if let l = record.object(forKey: "location") as? CLLocation {
                        location = l
                    } else {
                        location = CLLocation()
                    }

                    let identifier: String
                    if let i = record.object(forKey: "geonameid") as? String {
                        identifier = i
                    } else {
                        identifier = NSLocalizedString("n/a", comment: "The identifier of a city when the identifier is not available")
                    }

                    return City(identifier:identifier, countryCode: countryCode, name: name, location: location)
                })
                completion(cities, nil)
            }
        }
    }
}
