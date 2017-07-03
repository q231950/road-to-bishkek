//
//  City.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 02.07.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import Foundation
import CoreLocation

public struct City {
    let name: String
    let location: CLLocation

    static func == (left: City, right: City) -> Bool {
        let sameName = left.name == right.name
        let sameLocation = left.location == right.location
        return sameName && sameLocation
    }
}
