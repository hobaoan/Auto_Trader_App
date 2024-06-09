//
//  Predict.swift
//  AutoTrader
//
//  Created by An Bảo on 05/06/2024.
//

import Foundation

struct Forecast: Codable {
    var close: Double?
    var date: String?
    var high: Double?
    var low: Double?
    var open: Double?
    var forecast: Double?
    var signal: Double?
    var anomaly: Int?

    enum CodingKeys: String, CodingKey {
        case close = "Close"
        case date = "Date"
        case high = "High"
        case low = "Low"
        case open = "Open"
        case forecast
        case signal
        case anomaly
    }
}

func preprocessJSON(_ jsonString: String) -> String {
    return jsonString.replacingOccurrences(of: "NaN", with: "null")
}
