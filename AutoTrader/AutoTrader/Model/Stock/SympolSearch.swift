//
//  SympolSearch.swift
//  AutoTrader
//
//  Created by An Bảo on 04/07/2024.
//

import Foundation

struct SympolSearch: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
