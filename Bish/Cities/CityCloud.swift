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

    public func cityNamed(_ name: String, completion: @escaping (([String]?, Error?) -> Void)) {
        CKContainer.default().accountStatus { (accountStatus, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let predicate = NSPredicate(format: "self CONTAINS '\(name)'")
            let query = CKQuery(recordType: "Cities", predicate: predicate)
            let database = CKContainer.default().publicCloudDatabase
            database.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) in
                if let error = error {
                    print(error)
                }
                
                let names = records?.map({ (e: CKRecord) -> String in
                    return e.object(forKey: "name") as! String // TODO
                })
                completion(names, nil)
            }
        }
    }
}
