//
//  WeatherViewModel.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 31.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import Foundation

struct WeatherViewModel {
    
    let text: NSAttributedString
    
    init(json: Any) {
        let text = NSMutableAttributedString(string:"\n\n")
        
        guard let json = json as? [String:Any] else {
            self.text = text
            return
        }
        
        if let current = json["current"] as? [String:Any],
            let celsius = current["temp_c"] as? NSNumber,
            let feelsLikeCelsius = current["feelslike_c"] as? NSNumber,
            let windKilometers = current["wind_kph"] as? NSNumber,
            let humidity = current["humidity"] as? NSNumber,
            let windDirection = current["wind_dir"] as? String
        {
            text.append(celsius.stringValue.attributedBigText())
            text.append(" actual ºC feel like ".attributedSmallText())
            text.append(feelsLikeCelsius.stringValue.attributedBigText())
            text.append(" as there is a ".attributedSmallText())
            text.append(windKilometers.stringValue.attributedBigText())
            text.append("kph breeze blowing the air with a humidity of ".attributedSmallText())
            text.append(humidity.stringValue.attributedBigText())
            text.append(" into a ".attributedSmallText())
            text.append(windDirection.attributedBigText())
            text.append(" direction.".attributedSmallText())
        }
        
        self.text = text
    }
}
