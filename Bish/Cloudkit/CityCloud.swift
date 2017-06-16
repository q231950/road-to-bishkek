//
//  CityCloud.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 16.06.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import Foundation

public class CityCloud {
    
    public init() {
        
    }
    
    public func cities(_ completion: (([String]) -> Void)) throws {
        completion(["hamburg", "bishkek"])
    }
}
