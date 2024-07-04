//
//  StockSearch.swift
//  AutoTrader
//
//  Created by An Bảo on 03/07/2024.
//

import Foundation

struct StockSearch: Codable {
    var id: Int
    var symbol: String
    var todayPrice: Double
    var percentChange: Double
    var priceChange: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case symbol = "symbol"
        case todayPrice = "todayPrice"
        case percentChange = "percentChange"
        case priceChange = "priceChange"
    }
}
