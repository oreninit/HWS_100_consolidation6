//
//  Country.swift
//  Countries
//
//  Created by Oren Farhan on 15/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import Foundation

struct Country: Codable {
    let name: String
    let nativeName: String
    let capital: String
    let region: String
    let subregion: String
    let population: Int
    let latlng: [Double]
    let alpha3Code: String
    let borders: [String] // Of alpha3Code
    let flag: URL
    let callingCodes: [String]
    let timezones: [String]
}
