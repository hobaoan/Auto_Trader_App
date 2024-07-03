//
//  StockHold.swift
//  AutoTrader
//
//  Created by An Bảo on 10/06/2024.
//

import Foundation

struct StockHold: Codable {
    var userId: Int
    var stockId: Int
    var stockSymbol: String
    var total: Double
    var totalcapital: Double
    var unit: Int
    var percent: Double
    
    enum CodingKeys: String, CodingKey {
        case userId
        case stockId
        case stockSymbol
        case total
        case totalcapital
        case unit
        case percent
    }
}
