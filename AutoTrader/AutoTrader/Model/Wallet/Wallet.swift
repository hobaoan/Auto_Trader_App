//
//  Wallet.swift
//  AutoTrader
//
//  Created by An Bảo on 02/06/2024.
//

import Foundation

struct Wallet: Codable {
    var id: Int
    var balance: Double
    var total: Double
    var profit: Double
    var capital: Double
    var status: String?
    var percentProfit: Double
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case balance = "balance"
        case total = "total"
        case profit = "profit"
        case capital = "capital"
        case status = "status"
        case percentProfit = "percentProfit"
        case userId = "userId"
    }
}
