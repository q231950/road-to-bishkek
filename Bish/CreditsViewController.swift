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
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
}
