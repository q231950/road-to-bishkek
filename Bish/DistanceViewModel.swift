//
//  DistanceViewModel.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 27.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit
import CoreLocation

struct DistanceViewModel {
    public let attributedString: NSAttributedString
    
    init(city: City, distance: CLLocationDistance) {
        let combinedString = NSMutableAttributedString()
        
        let kilometers = DistanceViewModel.attributedKilometersStringWith(distance)
        combinedString.append(kilometers)
        
        let meters = DistanceViewModel.attributedMetersStringWith(distance)
        combinedString.append(meters)
        
        let centimeters = DistanceViewModel.attributedCentimetersStringWith(distance)
        combinedString.append(centimeters)
        
        let cityName = DistanceViewModel.attributedCityString(name: city.name)
        combinedString.append(cityName)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle]
        combinedString.addAttributes(attributes, range: NSMakeRange(0, combinedString.length))
        
        attributedString = combinedString
    }
    
    private static func attributedKilometersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "kilometers", value: Int((distance / 1000).rounded(.up)))
    }
    
    private static func attributedMetersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "meters", value: Int(distance.truncatingRemainder(dividingBy: 1000)))
    }
    
    private static func attributedCentimetersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "centimeters", value: Int((distance * 100).truncatingRemainder(dividingBy: 100)))
    }
    
    private static func attributedUnitString(unit: String, value: Int) -> NSAttributedString {
        let valueString = "\(value)".attributedBigText()
        let unitString = "\(unit) ".attributedSmallText()
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(valueString)
        combinedString.append(unitString)
        return combinedString
    }
    
    private static func attributedCityString(name: String) -> NSAttributedString {
        let valueString = "to".attributedSmallText()
        let unitString = "\(name)".attributedBigText()
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(valueString)
        combinedString.append(unitString)
        return combinedString
    }
}
