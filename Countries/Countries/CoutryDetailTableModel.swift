//
//  CoutryDetailTableModel.swift
//  Countries
//
//  Created by Oren Farhan on 16/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import Foundation

enum CountryDetail {
    enum SectionId: String {
        case information
        case borders
    }
    
    enum RowId: String {
        case information
        case border
    }
}

typealias CountryDetailTableModel = TableModel<CountryDetail.SectionId, CountryDetail.RowId>

extension TableModel where SectionId == CountryDetail.SectionId, RowId == CountryDetail.RowId {
    
    init(country: Country?, data: Countries?) {
        guard let country = country, let data = data else {
            sections = []
            return
        }
        
        
        var sections = [Section]()
        var rows = [Row]()
        
        rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
            cell.detailTextLabel?.text = "Capital"
            cell.textLabel?.text = country.capital
            cell.selectionStyle = .none
            return cell
        }))
        
        if !country.region.isEmpty {
            rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
                cell.detailTextLabel?.text = "Region"
                cell.textLabel?.text = country.region
                cell.selectionStyle = .none
                return cell
            }))
        }
        
        rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
            cell.detailTextLabel?.text = "Native name"
            cell.textLabel?.text = country.nativeName
            cell.selectionStyle = .none
            return cell
        }))
        
        rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            let num = NSNumber(value: country.population)
            cell.detailTextLabel?.text = "Population"
            cell.textLabel?.text = nf.string(from: num) ?? "\(country.population)"
            cell.selectionStyle = .none
            return cell
        }))
        
        rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
            cell.detailTextLabel?.text = "Calling code(s)"
            cell.textLabel?.text = country.callingCodes.joined(separator: ", ")
            cell.selectionStyle = .none
            return cell
        }))

        rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
            cell.detailTextLabel?.text = "Timezone(s)"
            cell.textLabel?.text = country.timezones.joined(separator: ", ")
            cell.selectionStyle = .none
            return cell
        }))
        
        if country.latlng.count == 2 {
            rows.append(Row(id: .information, cellId: "detail", cellConfig: { cell in
                cell.detailTextLabel?.text = "Coordinates"
                cell.textLabel?.text = country.latlng.map { String($0) }.joined(separator: ", ")
                cell.selectionStyle = .none
                return cell
            }))
        }

        sections.append(Section(id: .information, title: "Information", rows: rows))
        
        rows.removeAll()
        if country.borders.count > 0 {
            for border in country.borders {
                if let borderCountry = data.countries.first(where: { $0.alpha3Code == border }){
                    rows.append(Row(id: .border, cellId: "cell", cellConfig: { cell in
                        cell.textLabel?.text = "\(borderCountry.name)"
                        cell.selectionStyle = .gray
                        return cell
                    }))
                }
            }
            
            sections.append(Section(id: .borders, title: "Borders", rows: rows))
        }
        self.sections = sections
    }

}
