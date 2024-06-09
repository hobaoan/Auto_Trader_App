//
//  StockInfo.swift
//  AutoTrader
//
//  Created by An Bảo on 05/06/2024.
//

import Foundation

struct StockInfo: Codable {
    let id: Int
    let symbol: String
    let lastDate: String
    let lastDayPrice: Double
    let profitPercentYearToDate: Double
    let profitPercentLastYear: Double
    let profitPercent30Days: Double
    let profitPercent5YearsAgo: Double

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case lastDate = "lastDate"
        case lastDayPrice = "lastDayPrice"
        case profitPercentYearToDate = "profitPercentYearToDate"
        case profitPercentLastYear = "profitPercentLastYear"
        case profitPercent30Days = "profitPercent30Days"
        case profitPercent5YearsAgo = "profitPercent5YearsAgo"
    }
}
