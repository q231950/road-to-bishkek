//
//  CitySelectionViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 02.07.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit

class CitySelectionViewController: UITableViewController {
    
    private var filteredCities = [City]()
    private let searchResultsViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "City Selection"
        
        navigationItem.searchController = UISearchController(searchResultsController: searchResultsViewController)
        navigationItem.searchController?.searchResultsUpdater = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cloud = CityCloud()
        cloud.cityWithName(name: "San") { (names, error) in
            
        }
    }
}

extension CitySelectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
