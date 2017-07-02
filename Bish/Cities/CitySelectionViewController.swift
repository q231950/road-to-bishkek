//
//  CitySelectionViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 02.07.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit

class CitySelectionViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "City Selection"
        
        let searchViewController = UIViewController()
        navigationItem.searchController = UISearchController(searchResultsController: searchViewController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cloud = CityCloud()
        cloud.cityWithName(name: "San") { (names, error) in
            
        }
    }
}
