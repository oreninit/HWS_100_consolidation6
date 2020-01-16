//
//  Countries.swift
//  Countries
//
//  Created by Oren Farhan on 15/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import Foundation

class Countries {
    private(set) var countries = [Country]()
    
    func load(completion: @escaping () -> Void) {
        guard countries.count == 0 else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: URL(string: "https://restcountries.eu/rest/v2/all")!) { [weak self] data, _, err in
            
            guard let data = data else {
                print(err ?? "no error")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let list = try decoder.decode([Country].self, from: data)
                
                DispatchQueue.main.async {
                    self?.countries = list
                    completion()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
