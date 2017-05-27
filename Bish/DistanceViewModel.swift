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
    
    init(distance: CLLocationDistance) {
        let combinedString = NSMutableAttributedString()
        
        let kilometers = DistanceViewModel.attributedKilometersStringWith(distance)
        combinedString.append(kilometers)
        
        let meters = DistanceViewModel.attributedMetersStringWith(distance)
        combinedString.append(meters)
        
        let centimeters = DistanceViewModel.attributedCentimetersStringWith(distance)
        combinedString.append(centimeters)
        
        let city = DistanceViewModel.attributedCityString(name: "Bishkek")
        combinedString.append(city)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
        combinedString.addAttributes(attributes, range: NSMakeRange(0, combinedString.length))
        
        attributedString = combinedString
    }
    
    private static let kBigTextFontSize: CGFloat = 60
    private static let kBigTextFontName: String = "Menlo-Bold"
    private static let kSmallTextFontSize: CGFloat = 32
    private static let kSmallTextFontName: String = "Menlo"
    
    private static func attributedKilometersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "kilometers", value: Int(distance.divided(by: 1000).rounded(.up)))
    }
    
    private static func attributedMetersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "meters", value: Int(distance.truncatingRemainder(dividingBy: 1000)))
    }
    
    private static func attributedCentimetersStringWith(_ distance: CLLocationDistance) -> NSAttributedString {
        return attributedUnitString(unit: "centimeters", value: Int(distance.multiplied(by: 100).truncatingRemainder(dividingBy: 100)))
    }
    
    private static func bigTextAttributes() -> [String: Any] {
        return  [NSFontAttributeName: UIFont.init(name: kBigTextFontName, size: kBigTextFontSize)!,
                 NSForegroundColorAttributeName: UIColor.white]
    }
    
    private static func smallTextAttributes() -> [String: Any] {
        return [NSFontAttributeName: UIFont.init(name: kSmallTextFontName, size: kSmallTextFontSize)!,
                NSForegroundColorAttributeName: UIColor.white]
    }
    
    private static func attributedUnitString(unit: String, value: Int) -> NSAttributedString {
        let valueString = NSAttributedString(string: "\(value)", attributes: bigTextAttributes())
        let unitString = NSAttributedString(string: "\(unit)", attributes: smallTextAttributes())
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(valueString)
        combinedString.append(unitString)
        return combinedString
    }
    
    private static func attributedCityString(name: String) -> NSAttributedString {
        let valueString = NSAttributedString(string: "to", attributes: smallTextAttributes())
        let unitString = NSAttributedString(string: "\(name)", attributes: bigTextAttributes())
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(valueString)
        combinedString.append(unitString)
        return combinedString
    }
}
