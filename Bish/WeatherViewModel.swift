//
//  WeatherViewModel.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 31.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import Foundation

struct WeatherViewModel {
    
    let text: String
    
    init(json: Any) {
        text = "\n\(String(describing: json))"
    }
}
