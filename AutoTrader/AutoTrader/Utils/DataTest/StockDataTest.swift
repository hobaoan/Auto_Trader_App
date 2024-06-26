//
//  StockData.swift
//  AutoTrader
//
//  Created by An Bảo on 19/05/2024.
//

import Foundation

struct StockDataTest {
    let date: String
    let close: Double
}

func generateStockDataFromCSV() -> [StockDataTest] {
    var stockDataArray: [StockDataTest] = []
    
    let csvData = """
    05/17/2024,28500.0
    05/16/2024,28400.0
    05/16/2024,28400.0
    05/15/2024,27800.0
    05/15/2024,27800.0
    05/14/2024,27250.0
    05/14/2024,27250.0
    05/13/2024,27250.0
    05/13/2024,27250.0
    05/10/2024,27600.0
    05/10/2024,27600.0
    05/09/2024,27800.0
    05/09/2024,27800.0
    05/08/2024,27950.0
    05/08/2024,27950.0
    05/07/2024,28300.0
    05/07/2024,28300.0
    05/06/2024,28100.0
    05/06/2024,28100.0
    05/03/2024,27550.0
    05/03/2024,27550.0
    05/02/2024,27600.0
    05/02/2024,27600.0
    04/26/2024,28200.0
    04/25/2024,28450.0
    04/24/2024,28600.0
    04/23/2024,27800.0
    04/22/2024,27650.0
    04/19/2024,26800.0
    04/17/2024,26800.0
    04/16/2024,27300.0
    04/15/2024,27500.0
    04/12/2024,29100.0
    04/11/2024,28850.0
    04/10/2024,29100.0
    04/09/2024,29150.0
    04/08/2024,27600.0
    04/05/2024,30000.0
    04/04/2024,29700.0
    04/03/2024,30100.0
    04/02/2024,30200.0
    04/01/2024,31400.0
    03/29/2024,31600.0
    03/28/2024,28800.0
    03/27/2024,30900.0
    03/26/2024,31000.0
    03/25/2024,30850.0
    03/22/2024,31650.0
    03/21/2024,31500.0
    03/20/2024,31150.0
    03/19/2024,30400.0
    03/18/2024,30250.0
    03/15/2024,30500.0
    03/14/2024,30450.0
    03/13/2024,30850.0
    03/12/2024,30250.0
    03/11/2024,30200.0
    03/08/2024,30650.0
    03/07/2024,31300.0
    03/06/2024,31600.0
    03/05/2024,31900.0
    03/04/2024,31750.0
    03/01/2024,31950.0
    02/29/2024,31550.0
    02/28/2024,31400.0
    02/27/2024,30750.0
    02/26/2024,30500.0
    02/23/2024,30750.0
    02/22/2024,31050.0
    02/21/2024,31500.0
    02/20/2024,30700.0
    02/19/2024,30700.0
    02/16/2024,30800.0
    02/15/2024,31250.0
    02/07/2024,31100.0
    02/06/2024,30800.0
    02/05/2024,30600.0
    """
    
    let rows = csvData.components(separatedBy: "\n")
    
    for row in rows {
        let columns = row.components(separatedBy: ",")
        
        if columns.count >= 2 {
            let date = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let priceString = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let price = Double(priceString.replacingOccurrences(of: ",", with: "")) {
                let stockData = StockDataTest(date: date, close: price)
                stockDataArray.append(stockData)
            }
        }
    }
    return stockDataArray
}

func dataActual() -> [StockDataTest] {
    var stockDataArray: [StockDataTest] = []
    
    let csvData = """
    03/29/2024,31600.0
    03/28/2024,28800.0
    03/27/2024,30900.0
    03/26/2024,31000.0
    03/25/2024,30850.0
    03/22/2024,31650.0
    03/21/2024,31500.0
    03/20/2024,31150.0
    03/19/2024,30400.0
    03/18/2024,30250.0
    03/15/2024,30500.0
    03/14/2024,30450.0
    03/13/2024,30850.0
    03/12/2024,30250.0
    03/11/2024,30200.0
    03/08/2024,30650.0
    03/07/2024,31300.0
    03/06/2024,31600.0
    03/05/2024,31900.0
    03/04/2024,31750.0
    03/01/2024,31950.0
    02/29/2024,31550.0
    02/28/2024,31400.0
    02/27/2024,30750.0
    02/26/2024,30500.0
    02/23/2024,30750.0
    02/22/2024,31050.0
    02/21/2024,31500.0
    02/20/2024,30700.0
    02/19/2024,30700.0
    02/16/2024,30800.0
    02/15/2024,31250.0
    02/07/2024,31100.0
    02/06/2024,30800.0
    02/05/2024,30600.0
    """
    
    let rows = csvData.components(separatedBy: "\n")
    
    for row in rows {
        let columns = row.components(separatedBy: ",")
        
        if columns.count >= 2 {
            let date = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let priceString = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let price = Double(priceString.replacingOccurrences(of: ",", with: "")) {
                let stockData = StockDataTest(date: date, close: price)
                stockDataArray.append(stockData)
            }
        }
    }
    return stockDataArray
}

func dataPredicted() -> [StockDataTest] {
    var stockDataArray: [StockDataTest] = []
    
    let csvData = """
    05/17/2024,28500.0
    05/16/2024,28400.0
    05/16/2024,28400.0
    05/15/2024,27800.0
    05/15/2024,27800.0
    05/14/2024,27250.0
    05/14/2024,27250.0
    05/13/2024,27250.0
    05/13/2024,27250.0
    05/10/2024,27600.0
    05/10/2024,27600.0
    05/09/2024,27800.0
    05/09/2024,27800.0
    05/08/2024,27950.0
    05/08/2024,27950.0
    05/07/2024,28300.0
    05/07/2024,28300.0
    05/06/2024,28100.0
    05/06/2024,28100.0
    05/03/2024,27550.0
    05/03/2024,27550.0
    05/02/2024,27600.0
    05/02/2024,27600.0
    04/26/2024,28200.0
    04/25/2024,28450.0
    04/24/2024,28600.0
    04/23/2024,27800.0
    04/22/2024,27650.0
    04/19/2024,26800.0
    04/17/2024,26800.0
    04/16/2024,27300.0
    04/15/2024,27500.0
    04/12/2024,29100.0
    04/11/2024,28850.0
    04/10/2024,29100.0
    04/09/2024,29150.0
    04/08/2024,27600.0
    04/05/2024,30000.0
    04/04/2024,29700.0
    04/03/2024,30100.0
    04/02/2024,30200.0
    04/01/2024,31400.0
    """
    
    let rows = csvData.components(separatedBy: "\n")
    
    for row in rows {
        let columns = row.components(separatedBy: ",")
        
        if columns.count >= 2 {
            let date = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let priceString = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let price = Double(priceString.replacingOccurrences(of: ",", with: "")) {
                let stockData = StockDataTest(date: date, close: price)
                stockDataArray.append(stockData)
            }
        }
    }
    return stockDataArray
}
