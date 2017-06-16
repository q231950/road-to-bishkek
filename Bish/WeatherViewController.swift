//
//  WeatherViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 27.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weatherProvider = WeatherProvider()
        weatherProvider.weather(in: "bishkek") { (weatherViewModel: WeatherViewModel?, error: Error?) in
            DispatchQueue.main.async {
                self.textView.attributedText = weatherViewModel?.text
            }
        }
    }
}
