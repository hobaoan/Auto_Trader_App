//
//  AgentData.swift
//  AutoTrader
//
//  Created by An Bảo on 29/05/2024.
//

import Foundation

struct AgentData {
    let date: String
    let close: Double
    let action: String
}

func dataPredictedAgent() -> [AgentData] {
    var stockDataArray: [AgentData] = []
    
    let csvData = """
    05/17/2024,28500.0,0
    05/16/2024,28400.0,0
    05/16/2024,28400.0,1
    05/15/2024,27800.0,1
    05/15/2024,27800.0,0
    05/14/2024,27250.0,1
    05/14/2024,27250.0,0
    05/13/2024,27250.0,0
    05/13/2024,27250.0,1
    05/10/2024,27600.0,0
    05/10/2024,27600.0,0
    05/09/2024,27800.0,2
    05/09/2024,27800.0,0
    05/08/2024,27950.0,1
    05/08/2024,27950.0,1
    05/07/2024,28300.0,0
    05/07/2024,28300.0,0
    05/06/2024,28100.0,0
    05/06/2024,28100.0,2
    05/03/2024,27550.0,0
    05/03/2024,27550.0,0
    05/02/2024,27600.0,0
    05/02/2024,27600.0,2
    04/26/2024,28200.0,0
    04/25/2024,28450.0,0
    04/24/2024,28600.0,2
    04/23/2024,27800.0,0
    04/22/2024,27650.0,0
    04/19/2024,26800.0,1
    04/17/2024,26800.0,0
    04/16/2024,27300.0,1
    04/15/2024,27500.0,0
    04/12/2024,29100.0,0
    04/11/2024,28850.0,0
    04/10/2024,29100.0,2
    04/09/2024,29150.0,0
    04/08/2024,27600.0,1
    04/05/2024,30000.0,0
    04/04/2024,29700.0,1
    04/03/2024,30100.0,0
    04/02/2024,30200.0,2
    04/01/2024,31400.0,0
    """
    
    let rows = csvData.components(separatedBy: "\n")
    
    for row in rows {
        let columns = row.components(separatedBy: ",")
        
        if columns.count >= 3 {
            let date = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let priceString = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let action = columns[2].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let price = Double(priceString.replacingOccurrences(of: ",", with: "")) {
                let stockData = AgentData(date: date, close: price, action: action)
                stockDataArray.append(stockData)
            }
        }
    }
    return stockDataArray
}

