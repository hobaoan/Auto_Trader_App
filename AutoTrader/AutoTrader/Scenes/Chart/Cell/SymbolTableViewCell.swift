//
//  SymbolTableViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import UIKit
import Reusable
import SimpleLineChart

final class SymbolTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var sympolLabel: UILabel!
    @IBOutlet weak var miniChartView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var lineChart: SimpleLineChart!
    private var color = UIColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(stock: Stock) {
        sympolLabel.text = stock.symbol
        
        let stockDataArray = stock.stockDatas
        
        if stockDataArray.count >= 2, let lastStockData = stockDataArray.last {
            let secondLastStockData = stockDataArray[stockDataArray.count - 2]
            
            priceLabel.text = lastStockData.close.formattedWithSeparator()
            
            if lastStockData.close > secondLastStockData.close {
                priceLabel.textColor = .greenStock
                color = .greenStock
            } else {
                priceLabel.textColor = .redStock
                color = .redStock
            }
        } else if let lastStockData = stockDataArray.last {
            priceLabel.text = lastStockData.close.formattedWithSeparator()
            priceLabel.textColor = .white
        } else {
            priceLabel.text = "N/A"
            priceLabel.textColor = .white
        }
    }
    
    func setupChart(stockDatas: [StockData]) {
        let values = stockDatas.enumerated().map { index, data in
            return SLCData(x: index, y: data.close)
        }
        
        lineChart = SimpleLineChart(frame: miniChartView.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: color,
                                     lineStroke: 1.4,
                                     lineShadow: false)
        dataSet.setLineStyle(lineStyle)
        miniChartView.addSubview(lineChart)
    }
}
