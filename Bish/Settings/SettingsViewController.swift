//
//  SettingsViewController.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 19.06.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
}

// MARK: UITableViewDataSource
extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        switch Row(rawValue: indexPath.row)!.rawValue {
        case Row.citySelectionRow.rawValue:
            cell.textLabel?.text = "City Selection"
        case Row.creditsRow.rawValue:
            cell.textLabel?.text = "Credits"
        default:
            print("not implemented")
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SettingsViewController {
    enum Row: Int {
        case citySelectionRow = 0, creditsRow
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row(rawValue: indexPath.row)!.rawValue {
        case Row.citySelectionRow.rawValue:
            performSegue(withIdentifier: "showCitySelection", sender: nil)
        case Row.creditsRow.rawValue:
            performSegue(withIdentifier: "showCredits", sender: nil)
        default:
            print("not implemented")
        }
    }
}
