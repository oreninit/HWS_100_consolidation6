//
//  ViewController.swift
//  Countries
//
//  Created by Oren Farhan on 15/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import UIKit

private enum Section: String {
    case countries
}

class ViewController: UITableViewController {
    private let data = Countries()
    
    fileprivate var dataSource: UITableViewDiffableDataSource<Section, Country>!
    fileprivate var snapshot: NSDiffableDataSourceSnapshot<Section, Country>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coutries"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSearch()
        configureDataSource()
        data.load { [weak self] result in
            self?.updateUI(items: result, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let country = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailViewController.create(storyboard: storyboard,
                                             data: data,
                                             country: country)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController {
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource
            <Section, Country>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: Country) -> UITableViewCell? in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "country",
                    for: indexPath)
                cell.textLabel?.text = item.name
                cell.detailTextLabel?.text = [item.subregion, item.region].compactMap({ $0.count > 0 ? $0 : nil }).joined(separator: ", ")

                return cell
        }
        dataSource.defaultRowAnimation = .automatic
    }

    func updateUI(items: [Country], animated: Bool) {
        snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections([.countries])
        snapshot.appendItems(items, toSection: .countries)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension ViewController: UISearchResultsUpdating {
    func configureSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type country name..."
        navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return updateUI(items: data.countries, animated: true)
        }
        
        let countries = data.countries.filter({ $0.name.contains(text) })
        return updateUI(items: countries, animated: true)
    }
}
