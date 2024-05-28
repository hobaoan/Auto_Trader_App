//
//  Stock.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import Foundation

struct Stock: Codable {
    var symbol: String
    var description: String?
    var stockDatas: [StockData]
    
    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case description = "description"
        case stockDatas = "stockDatas"
    }
}
