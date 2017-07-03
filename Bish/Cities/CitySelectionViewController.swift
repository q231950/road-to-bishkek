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
    private let cloud = CityCloud()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupSearchController()
    }
    
    private func setupTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "City Selection"
    }
    
    private func setupSearchController() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
}

extension CitySelectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let name = searchController.searchBar.text else {
            return
        }

        cloud.cityWithName(name: name) { (names, error) in
            let cities = names?.map({ (name: String) -> City in
                return City(name: name)
            })

            if let cities = cities {
                self.filteredCities = cities
            } else {
                self.filteredCities.removeAll()
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CitySelectionViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.text = filteredCities[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
}
