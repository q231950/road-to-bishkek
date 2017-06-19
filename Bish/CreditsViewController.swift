//
//  CreditsViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 26.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Credits"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cloud = CityCloud()
        do {
            try cloud.cityWithName(name: "kala") { (names) in
                
        }
        } catch _ {
            
        }
    }
    
}
