//
//  DetailViewController.swift
//  Countries
//
//  Created by Oren Farhan on 15/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import UIKit

extension DetailViewController {
    class func create(storyboard: UIStoryboard?, data: Countries, country: Country) -> DetailViewController {
        guard let detail = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { fatalError() }
        detail.data = data
        detail.country = country
        return detail
    }
}
class DetailViewController: UITableViewController {
    var data: Countries!
    var country: Country!
    
    var model: CountryDetailTableModel = CountryDetailTableModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = country.name
        model = CountryDetailTableModel(country: country, data: data)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = model.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellId, for: indexPath)
        return row.cellConfig(cell)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = model.sections[indexPath.section]
        guard section.id == .borders else { return }
        let row = section.rows[indexPath.row]
        guard row.id == .border else { return }
        let cell = tableView.cellForRow(at: indexPath)
        guard let countryName = cell?.textLabel?.text else { return }
        guard let country = data.countries.first(where: { $0.name == countryName }) else { return }
        
        let vc = DetailViewController.create(storyboard: storyboard,
                                             data: data,
                                             country: country)
        navigationController?.pushViewController(vc, animated: true)
    }
}
