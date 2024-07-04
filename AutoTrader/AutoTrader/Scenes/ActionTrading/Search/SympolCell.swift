//
//  SympolCell.swift
//  AutoTrader
//
//  Created by An Bảo on 04/07/2024.
//

import UIKit

class SympolCell: UITableViewCell {
    
    func setContent(sympolSearch: SympolSearch) {
        textLabel?.text = sympolSearch.name
    }
}
