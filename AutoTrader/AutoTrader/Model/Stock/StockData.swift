//
//  StockData.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import Foundation

struct StockData: Codable {
    var date: String
    var close: Double
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case close = "close"
    }
}
