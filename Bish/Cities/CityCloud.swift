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
    
    public init() {
        
    }
    
    public func cityWithName(name: String, completion: @escaping (([String]?, Error?) -> Void)) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let predicate = NSPredicate(format: "name CONTAINS[dc] '\(name)'")
            let query = CKQuery(recordType: "city", predicate: predicate)
            let database = CKContainer.default().publicCloudDatabase
            database.perform(query, inZoneWith: nil) { (record: [CKRecord]?, error: Error?) in
                print(record as Any)
            }
        }
    }
}
