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

    let queue = OperationQueue()

    init() {
        queue.qualityOfService = .userInitiated
    }

    private func predicateFormat(tokenString: String) -> String {
        let contains = tokenString.split(separator: " ").enumerated().map { (arg) -> String in

            let (index, element) = arg
            let and = index == 0 ? "":" AND"
            return "\(and) self CONTAINS '\(element)'"
        }

        return contains.joined()
    }
    
    public func citiesNamed(_ name: String, cursor: CKQueryCursor?, completion: @escaping ((City?, Error?) -> Void), next: @escaping (CKQueryCursor?) -> Void ) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let database = CKContainer.default().publicCloudDatabase
            let operation: CKQueryOperation
            if let c = cursor {
                operation = CKQueryOperation(cursor: c)
            } else {
                let format = self.predicateFormat(tokenString: name)
                let predicate = NSPredicate(format: format)
                let query = CKQuery(recordType: "City", predicate: predicate)
                let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                let countrySortDescriptor = NSSortDescriptor(key: "countrycode", ascending: true)
                query.sortDescriptors = [nameSortDescriptor, countrySortDescriptor]
                
                operation = CKQueryOperation(query: query)
            }
            operation.database = database
            operation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: Error?) in
                next(cursor)
            }
            operation.recordFetchedBlock = { (record: CKRecord) in
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
                
                let city = City(identifier:identifier, countryCode: countryCode, name: name, location: location)
                completion(city, error)
            }
            self.queue.addOperation(operation)
        }
    }
}
