//
//  Login.swift
//  AutoTrader
//
//  Created by An Bảo on 02/06/2024.
//

import Foundation

struct Login: Codable {
    var id: Int
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case token = "token"
    }
}

