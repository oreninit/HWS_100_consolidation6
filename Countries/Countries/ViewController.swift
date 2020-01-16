//
//  ViewController.swift
//  Countries
//
//  Created by Oren Farhan on 15/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let data = Countries()
    var countries: [Country] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coutries"
        navigationController?.navigationBar.prefersLargeTitles = true
        createSearch()
        data.load { [weak self] in
            self?.countries = self?.data.countries ?? []
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = [country.subregion, country.region].compactMap({ $0.count > 0 ? $0 : nil }).joined(separator: ", ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = countries[indexPath.row]
        let vc = DetailViewController.create(storyboard: storyboard,
                                             data: data,
                                             country: country)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func createSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type country name..."
        navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            countries = data.countries
            return
        }
        
        countries = data.countries.filter({ $0.name.contains(text) })
    }
}
