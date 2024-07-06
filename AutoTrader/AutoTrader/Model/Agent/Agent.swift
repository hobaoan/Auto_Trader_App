//
//  Agent.swift
//  AutoTrader
//
//  Created by An Bảo on 01/06/2024.
//

import Foundation

struct Agent: Codable {
    let action: Int
    let balance: Double
    let close: Double
    let date: String
    let status: String
    let timestamp: String
    let averageInvestmentReturn: Double?
    let investment: Double?
    let total: Double?
    let gain: Double?

    enum CodingKeys: String, CodingKey {
        case action, balance, close, date, status, timestamp
        case averageInvestmentReturn = "average_investment_return"
        case investment, total
        case gain = "gain"
    }
}
