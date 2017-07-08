//
//  CitySelectionViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 02.07.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class CitySelectionViewController: UITableViewController {

    public var selectedCity: City?
    private var filteredCities = [City]()
    private let cloud = CityCloud()
    private var searchTermChanged = false
    private var searchTerm: String?
    private var updateTimer: Timer!
    private var cursor: CKQueryCursor?
    
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
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updateTimer.invalidate()
    }

    private func setupTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (_) in
            self?.updateResults(cursor: self?.cursor)
        })
    }
}

extension CitySelectionViewController: UISearchResultsUpdating {

    func loadMore() {
        searchTermChanged = true
        updateResults(cursor: cursor)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let name = searchController.searchBar.text, name.count > 0 else {
            return
        }

        searchTerm = name
        searchTermChanged = true
    }

    private func updateResults(cursor: CKQueryCursor?) {

        guard let name = searchTerm, searchTermChanged == true else {
            return
        }

        searchTermChanged = false

        var newCursor: CKQueryCursor?

        if cursor == nil {
            filteredCities.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            newCursor = cursor
            self.cursor = nil
        }

//        DispatchQueue.main.async {
//            self.tableView.performBatchUpdates({
                self.cloud.citiesNamed(name, cursor: newCursor, completion: { (city, error) in
                    if let city = city {
                        self.filteredCities.append(city)
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        let indexPath = IndexPath.init(row: self.filteredCities.count-1, section: 0)
//                        self.tableView.insertRows(at: [indexPath], with: .fade)
                    }
                }, next: { (cursor) in
                    self.cursor = cursor
                })
//            }) { (done) in
//
//            }
//        }

    }
}

extension CitySelectionViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        let city = filteredCities[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.countryCode

        if let selectedCity = selectedCity {
            cell.accessoryType = selectedCity == city ? .checkmark : .none
        }

        if indexPath.row == filteredCities.count - 1 && cursor != nil {
            loadMore()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = filteredCities[indexPath.row]
            selectedCity = city

            do {
                try DataStore.shared.deselectAllCities()
                try DataStore.shared.select(city)
                DataStore.shared.saveContext()
            } catch {
        }

        DispatchQueue.main.async {
            self.navigationItem.searchController?.isActive = false
            self.tableView.reloadData()
        }
    }
}

extension CitySelectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cursor = nil
    }
}
