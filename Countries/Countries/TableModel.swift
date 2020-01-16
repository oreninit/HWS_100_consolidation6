//
//  TableModel.swift
//  Countries
//
//  Created by Oren Farhan on 15/01/2020.
//  Copyright © 2020 Oren Farhan. All rights reserved.
//

import UIKit

struct TableModel<SectionId, RowId> {
    let sections: [Section]
    
    struct Row {
        let id: RowId
        let cellId: String
        let cellConfig: (UITableViewCell) -> UITableViewCell
    }
    
    struct Section {
        let id: SectionId
        let title: String?
        let rows: [Row]
    }
}

extension TableModel {
    init() {
        sections = []
    }
}
