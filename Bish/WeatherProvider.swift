//
//  WeatherProvider.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 27.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import Foundation

class WeatherProvider {
    
    public func weather(in city:City, completion: @escaping ((WeatherViewModel?, Error?) -> Swift.Void)) {
        if let url = URL(string: "https://api.apixu.com/v1/current.json?key=\(ApiKey.weather.rawValue)&q=\(city.location.coordinate.latitude),\(city.location.coordinate.longitude)") {
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        let viewModel = WeatherViewModel(json:json)
                        completion(viewModel, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                }
                
            })
            
            dataTask.resume()
        }
    }
    
}
